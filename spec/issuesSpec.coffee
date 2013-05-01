self = require: unless typeof require is "undefined" then require else JUMLY.require

self.require "node-jquery"
SequenceDiagramBuilder = self.require "SequenceDiagramBuilder"
SequenceDiagramLayout  = self.require "SequenceDiagramLayout"
utils = self.require "./jasmine-utils"

describe "issues", ->
  
  div = utils.div this

  describe "#15", ->

    it "is empty for the .condition of fragment", ->
      code = '''
             @found "a", ->
               @loop "[until i > 100]", ->
                 @message "touch", "@create", ->
                 @fragment "critial section": ->
                   @message "select", "Context"
             '''
      diag = (new SequenceDiagramBuilder).build code

      conds = diag.find(".condition")
      expect(conds.length).toBe 2
      expect(conds.filter(":eq(0)").text()).toBe "[until i > 100]"
      expect(conds.filter(":eq(1)").text()).toBe ""
  
  utils.unless_node -> describe "#12", ->
  
    describe "@create", ->
      it "is that message starts from the bottom of occurrence", ->
        diag = (new SequenceDiagramBuilder).build '''
          @found "You", ->
            @create "Diagram", ->
              @reply "400"
          '''
        div.append diag
        (new SequenceDiagramLayout).layout diag

        occur = diag.find ".occurrence:eq(1)"
        rmsg  = diag.find ".message.return"
        bottom = occur.offset().top + occur.height() - 1
        top    = rmsg.offset().top
        expect(top).toBeGreaterThan bottom
      
    describe "@message", ->
      it "is that message starts from the bottom of occurrence", ->
        diag = (new SequenceDiagramBuilder).build '''
          @found "You", ->
            @message "get", "Diagram", ->
              @reply "200"
          '''
        div.append diag
        (new SequenceDiagramLayout).layout diag

        occur = diag.find ".occurrence:eq(1)"
        rmsg  = diag.find ".message.return"
        bottom = occur.offset().top + occur.height() - 1
        top    = rmsg.offset().top
        expect(top).toBeLessThan bottom