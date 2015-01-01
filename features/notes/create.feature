Feature: Create a note
  In order to remember important things
  As a forgetful man
  I want to create note on Qiq

  Scenario: User create inline note
    When I successfully run `qiq note --content "Cool note"`
    Then a note should be created on the server with:
      """
      Cool note
      """
    And the output should match /\(Created note *(\d+)\)/

  Scenario: User create note in buffer
    When I successfully run `qiq note -c "Cool note" -b my/buffer`
    Then a note should be created on the server
    And the buffer "my/buffer" should exist on the server
    And the buffer "my/buffer" should contain the note
    And the output should match /\(Created note *(\d+) in @my/buffer\)/

  Scenario: User create note with tags
    When I successfully run `qiq note -c "Cool note" -t my-tag`
    Then a note should be created on the server
    And the tag "tag1" should exist on the server
    And the note should have the tag "my-tag"
    And the output should match /\(Created note *(\d+) with #my-tag\)/

  Scenario: User create note from file
    Given a file named "note.txt" with:
      """
      Cool note in a file
      """
    When I successfully run `qiq note -f note.txt`
    Then a note should be created on the server with:
      """
      Cool note in a file
      """

  Scenario: User create note from pipe
    When I successfully run `echo "Note from pipe" | qiq note`
    Then a note should be created on the server with:
      """
      Note from pipe
      """

  Scenario: User create note in Vim
