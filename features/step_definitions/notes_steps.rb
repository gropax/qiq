Then /^a note should be created on the server with:$/ do |content|
  expect(WebMock).to have_requested(:post, "www.gropax.ninja/notes").with({
    body: hash_including({note: {content: content}})
  })
end
