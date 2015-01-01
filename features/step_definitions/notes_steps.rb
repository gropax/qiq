Given /^I want to create a new note$/ do
  stub_request(:post, "www.gropax.ninja/notes.json").to_return(status: 201)
end

Then /^a note should be created on the server with:$/ do |content|
  expect(WebMock).to have_requested(:post, "www.gropax.ninja/notes").with({
    body: hash_including({note: {content: content}})
  })
end
