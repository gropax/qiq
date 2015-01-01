Given /^I want to create a new note$/ do
  stub_request(:post, "www.gropax.ninja/notes.json").
    to_return(status: 201) { |req|
    note = {note: {
      id: 123,
      content: JSON.parse(req.body)[:content],
      created_at: Time.now,
      updated_at: Time.now,
    }}
    {body: note.to_json}
  }
end

Then /^a note should be created on the server with:$/ do |content|
  expect(WebMock).to have_requested(:post, "www.gropax.ninja/notes.json").with({
    body: hash_including({content: content})
  })
end
