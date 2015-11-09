describe "Cache Manifest grammar", ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage "language-appcache"

    runs ->
      grammar = atom.grammars.grammarForScopeName "text.appcache"

  it "parses the grammar", ->
    expect(grammar).toBeTruthy()
    expect(grammar.scopeName).toBe "text.appcache"

  it "tokenizes first line", ->
    {tokens} = grammar.tokenizeLine("CACHE MANIFEST a")
    expect(tokens[0]).toEqual value: "CACHE MANIFEST", scopes: ["text.appcache", "keyword.appcache"]
    expect(tokens[1]).toEqual value: " a", scopes: ["text.appcache"]


  describe "keywords", ->
    for keyword in [ "CACHE", "NETWORK", "FALLBACK" ]
      do (keyword) ->
        it "tokenizes #{keyword} keyword", ->
          {tokens} = grammar.tokenizeLine("#{keyword}: foo")
          expect(tokens[0]).toEqual value: keyword, scopes: ["text.appcache", "keyword.appcache"]
          expect(tokens[1]).toEqual value: ":", scopes: ["text.appcache", "keyword.operator.appcache"]
          expect(tokens[2]).toEqual value: " foo", scopes: ["text.appcache"]

  it "tokenizes comments", ->
    {tokens} = grammar.tokenizeLine("/ /index.html #yo")
    expect(tokens[0]).toEqual value: "/ /index.html ", scopes: ["text.appcache"]
    expect(tokens[1]).toEqual value: "#yo", scopes: ["text.appcache", "comment.line.appcache"]
