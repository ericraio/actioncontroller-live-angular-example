require "spec_helper"

describe Identity do

  it { should be_mongoid_document }
  it { should be_timestamped_document }
  it { should have_field(:uid).of_type(String) }
  it { should have_field(:provider).of_type(String) }
  it { should have_field(:token).of_type(String) }
  it { should have_field(:secret).of_type(String) }
  it { should have_field(:expires_at).of_type(DateTime) }

  it { should have_field(:email).of_type(String) }
  it { should have_field(:image).of_type(String) }
  it { should have_field(:nickname).of_type(String) }
  it { should have_field(:first_name).of_type(String) }
  it { should have_field(:last_name).of_type(String) }

  it { should belong_to(:user) }



  describe "#full_name" do
    it "should return the full name" do
      Identity.new(first_name: 'eric', last_name: 'raio').full_name.should == 'eric raio'
    end
  end

  describe "#name" do
    it "should return the name" do
      Identity.new(first_name: 'eric', last_name: 'raio').name.should == 'Eric R.'
    end
  end

  describe "#self.from_omniauth(auth)" do
    before :each do
      @identity = mock(
        Identity,
        persisted?: true,
        save!: true,
        slice: nil,
        provider: 'Facebook',
        uid: '123',
        credentials: mock('token', token: 'tokez', secret: 'shhsecretshh', expires_at: Time.now),
        info: mock('info', email: 'me@example.com', image: 'me.jpg', nickname: 'Atrosity', first_name: 'Eric', last_name: 'Raio')
      )
      @array = mock(Array, first_or_create: @identity)
      Identity.stub(:where).and_return(@array)
      @auth = { provider: @identity.provider, uid: @identity.uid }
    end
    it "should look up the identity" do
      Identity.should_receive(:where).with(provider: 'Facebook', uid: '123').and_return(@array)
      Identity.from_omniauth(@auth)
    end
    describe "creating a user" do
      before :each do
        String.any_instance.stub(:save!)
        String.any_instance.stub(:persisted?).and_return(true)
        Identity.stub(:where).and_return(@array)
        @array.should_receive(:first_or_create).and_yield(@identity)
        @identity.stub(:provider=).with(@identity.provider)
        @identity.stub(:uid=).with(@identity.uid)
        @identity.stub(:token=).with(@identity.credentials.token)
        @identity.stub(:secret=).with(@identity.credentials.secret)
        @identity.stub(:expires_at=).with(@identity.credentials.expires_at)
        @identity.stub(:email=).with(@identity.info.email)
        @identity.stub(:image=).with(@identity.info.image)
        @identity.stub(:nickname=).with(@identity.info.nickname)
        @identity.stub(:first_name=).with(@identity.info.first_name)
        @identity.stub(:last_name=).with(@identity.info.last_name)
      end
      it "should setup the attributes the user needs to be created" do
        @identity.should_receive(:provider=).with(@identity.provider)
        @identity.should_receive(:uid=).with(@identity.uid)
        @identity.should_receive(:token=).with(@identity.credentials.token)
        @identity.should_receive(:secret=).with(@identity.credentials.secret)
        @identity.should_receive(:expires_at=).with(@identity.credentials.expires_at)
        @identity.should_receive(:email=).with(@identity.info.email)
        @identity.should_receive(:image=).with(@identity.info.image)
        @identity.should_receive(:nickname=).with(@identity.info.nickname)
        @identity.should_receive(:first_name=).with(@identity.info.first_name)
        @identity.should_receive(:last_name=).with(@identity.info.last_name)
        Identity.from_omniauth(@identity)
      end
      it "should not set the secret when creating the user if there is no secret" do
        @identity.credentials.stub(:secret).and_return(nil)
        @identity.should_not_receive(:secret=)
        Identity.from_omniauth(@identity)
      end
      it "should not set the expire at time when creating the user if there is expire at time" do
        @identity.credentials.stub(:expires_at).and_return(nil)
        @identity.should_not_receive(:expires_at=)
        Identity.from_omniauth(@identity)
      end
      it "should not set the email when creating the user if there is no email" do
        @identity.info.stub(:email).and_return(nil)
        @identity.should_not_receive(:email=)
        Identity.from_omniauth(@identity)
      end
      it "should not set the image when creating the user if there is no image" do
        @identity.info.stub(:image).and_return(nil)
        @identity.should_not_receive(:image=)
        Identity.from_omniauth(@identity)
      end
    end
    it "should save the identity" do
      @identity.should_receive(:save!)
      Identity.from_omniauth(@auth)
    end
    it "should check if the identity is persisted" do
      @identity.should_receive(:persisted?)
      Identity.from_omniauth(@auth)
    end
    it "should redirect to the root url if the identity didn't persist" do
      @identity.stub(:persisted?).and_return(false)
      Identity.should_receive(:root_url).and_return('/')
      Identity.should_receive(:redirect_to).with('/', { alert: "Something went wrong, please try again." })
      Identity.from_omniauth(@auth)
    end
    it "should not redirect to the root url if the identity did persist" do
      @identity.stub(:persisted?).and_return(true)
      Identity.should_not_receive(:redirect_to)
      Identity.from_omniauth(@auth)
    end
    it "should return the identity object" do
      Identity.from_omniauth(@auth).should == @identity
    end
  end

  describe "#find_or_create_user(current_user)" do
    before :each do
      @user = User.new(
        username: 'atrosity',
        email: 'x@y.com',
        avatar: nil,
        first_name: nil,
        last_name: nil
      )
      @identity = Identity.new(
        user: @user,
        first_name: 'Eric',
        last_name: 'Raio',
        image: 'img.jpg',
        email: 'example@example.com'
      )
    end
    it "should return the user if the user being created is the current user" do
      @identity.stub(:user).and_return(@user)
      @identity.find_or_create_user(@user).should == @user
    end
    it "should return the updated user if the identity's user doesn't match up to the current user" do
      @current_user = FactoryGirl.create(:user)
      @identity.stub(:user).and_return(@user)
      @identity.should_receive(:user=).with(@current_user)
      @identity.user.should_receive(:email=).with(@identity.email)
      @identity.user.should_receive(:avatar=).with(@identity.image)
      @identity.user.should_receive(:first_name=).with(@identity.first_name)
      @identity.user.should_receive(:last_name=).with(@identity.last_name)
      @identity.user.should_receive(:save!)
      @identity.should_receive(:save!)
      @identity.find_or_create_user(@current_user).should == @user
    end
    it "should return the logged out user" do
      @identity.user.should_receive(:present?).and_return(true)
      @identity.find_or_create_user(nil).should == @user
    end
    it "should create a user if no user is associated to the identity" do
      @identity.user.should_receive(:present?).and_return(false)
      @identity.should_receive(:build_user).with({
        email: @identity.email,
        avatar: @identity.image,
        first_name: @identity.first_name,
        last_name: @identity.last_name
      })
      @user.should_receive(:save!).with(validate: false)
      @identity.should_receive(:save!)
      @identity.find_or_create_user(nil).should == @user
    end
  end
end
