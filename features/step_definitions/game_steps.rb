def create_game
  @game = Game.create(title: 'Zelda')
end

When(/^I look at a game page$/) do
  create_game
  visit '/game/zelda'
end

Then(/^I should see the game title$/) do
  page.should have_content @game.title
end
