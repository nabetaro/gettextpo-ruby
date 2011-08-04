# -*- coding: utf-8 -*-
# Copyright (C) 2011 KURASAWA Nozomu (nabetaro)
# mailto: nabetaro@caldron.jp

# This Spec file is described in Japanese.

require "stringio"

$LOAD_PATH.unshift "#{File.dirname __FILE__}/../lib"
require "gettextpo"


describe GettextPo, "は" do
  context "生成したとき" do
    context "エントリがないpoファイルを渡すと" do
      before do
        @no_entry = StringIO.new(<<EOS)
msgid ""
msgstr ""
"Project-Id-Version: sample_app 0.0.1\\n"
"Report-Msgid-Bugs-To: \\n"
"POT-Creation-Date: 2011-01-01 12:34+0900\\n"
"PO-Revision-Date: 2011-01-11 13:57+0900\\n"
"Last-Translator: KURASAWA Nozomu <nabetaro@example.com>\\n"
"Language-Team: Example Team <team@example.com>\\n"
"Language: ja_JP\\n"
"MIME-Version: 1.0\\n"
"Content-Type: text/plain; charset=UTF-8\\n"
"Content-Transfer-Encoding: 8 bit\\n"
EOS
      end
      it "size == 0 である" do
        po = GettextPo.new(@no_entry)
        po.size.should == 0
      end
      it "entry は empty である" do
        po = GettextPo.new(@no_entry)
        po.entry.should be_empty
      end
    end
    context "1エントリのpoファイルを渡すと" do
      before do
        @one_entry = StringIO.new(<<EOS)
msgid ""
msgstr ""
"Project-Id-Version: sample_app 0.0.1\\n"
"Report-Msgid-Bugs-To: \\n"
"POT-Creation-Date: 2011-01-01 12:34+0900\\n"
"PO-Revision-Date: 2011-01-11 13:57+0900\\n"
"Last-Translator: KURASAWA Nozomu <nabetaro@example.com>\\n"
"Language-Team: Example Team <team@example.com>\\n"
"Language: ja_JP\\n"
"MIME-Version: 1.0\\n"
"Content-Type: text/plain; charset=UTF-8\\n"
"Content-Transfer-Encoding: 8 bit\\n"

msgid "Hello, World.\\n"
msgstr "こんにちわ、世界\\n"
EOS
      end
      it "size == 1 である" do
        po = GettextPo.new(@one_entry)
        po.size.should == 1
      end
      it "entry は GettextPo::Entryのインスタンスを1つ持つ配列である" do
        po = GettextPo.new(@one_entry)
        po.entry.should have(1).item
        po.entry[0].should be_instance_of GettextPo::Entry
        po.entry[0].msgid.should == ["Hello, World.\n"]
        po.entry[0].msgstr.should == ["こんにちわ、世界\n"]
      end
    end
    context "2エントリのpoファイルを渡すと" do
      before do
        @two_entry = StringIO.new(<<EOS)
msgid ""
msgstr ""
"Project-Id-Version: sample_app 0.0.1\\n"
"Report-Msgid-Bugs-To: \\n"
"POT-Creation-Date: 2011-01-01 12:34+0900\\n"
"PO-Revision-Date: 2011-01-11 13:57+0900\\n"
"Last-Translator: KURASAWA Nozomu <nabetaro@example.com>\\n"
"Language-Team: Example Team <team@example.com>\\n"
"Language: ja_JP\\n"
"MIME-Version: 1.0\\n"
"Content-Type: text/plain; charset=UTF-8\\n"
"Content-Transfer-Encoding: 8 bit\\n"

msgid "Hello, World.\\n"
msgstr "こんにちわ、世界\\n"

msgid ""
"Good-bye, World.\\n"
"See you again."
msgstr ""
"さよなら、世界\\n"
"また会う日まで"
EOS
      end
      it "size = 2 である" do
        po = GettextPo.new(@two_entry)
        po.size.should == 2
      end
      it "entry は GettextPo::Entryのインスタンスを2つ持つ配列である" do
        po = GettextPo.new(@two_entry)
        po.entry.should have(2).items
        po.entry[0].should be_instance_of GettextPo::Entry
        po.entry[0].msgid.should == ["Hello, World.\n"]
        po.entry[0].msgstr.should == ["こんにちわ、世界\n"]
        po.entry[1].should be_instance_of GettextPo::Entry
        po.entry[1].msgid.should == ["Good-bye, World.\nSee you again."]
        po.entry[1].msgstr.should == ["さよなら、世界\nまた会う日まで"]
      end
    end
  end

  context "header は" do
    before do
      @header_entry = StringIO.new(<<EOS)
msgid ""
msgstr ""
"Project-Id-Version: sample_app 0.0.1\\n"
"Report-Msgid-Bugs-To: \\n"
"POT-Creation-Date: 2011-01-01 12:34+0900\\n"
"PO-Revision-Date: 2011-01-11 13:57+0900\\n"
"Last-Translator: KURASAWA Nozomu <nabetaro@example.com>\\n"
"Language-Team: Example Team <team@example.com>\\n"
"Language: ja_JP\\n"
"MIME-Version: 1.0\\n"
"Content-Type: text/plain; charset=UTF-8\\n"
"Content-Transfer-Encoding: 8 bit\\n"
EOS
      end
    it "GettextPo::Header のインスタンスである" do
      po = GettextPo.new(@header_entry)
      po.header.should be_instance_of GettextPo::Header
      po.header.header?.should be_true
    end
  end
end

describe GettextPo::Entry, "は" do
  before do
    @po_file = StringIO.new(<<EOS)
# Translation of 'sample_app' message to Japanese
# Copyright (C) 2011 KURASAWA Nozomu (nabetaro)
msgid ""
msgstr ""
"Project-Id-Version: sample_app 0.0.1\\n"
"Report-Msgid-Bugs-To: \\n"
"POT-Creation-Date: 2011-01-01 12:34+0900\\n"
"PO-Revision-Date: 2011-01-11 13:57+0900\\n"
"Last-Translator: KURASAWA Nozomu <nabetaro@example.com>\\n"
"Language-Team: Example Team <team@example.com>\\n"
"Language: ja_JP\\n"
"MIME-Version: 1.0\\n"
"Content-Type: text/plain; charset=UTF-8\\n"
"Content-Transfer-Encoding: 8 bit\\n"

# simple message
#. sample of simple message
#: lib/sample.c:133
#, c-format
#| msgid "Hello, world!!"
msgid "Hello, World.\\n"
msgstr "こんにちわ、世界\\n"

# multiline message
#. sample of multiline message
#: lib/sample.c:255
#, c-format
msgid ""
"Good-bye, World.\\n"
"See you again."
msgstr ""
"さよなら、世界\\n"
"また会う日まで"

# untranslated message
#. sample of untransrated message
#: lib/sample.c:271
#, c-format
msgid ""
"Welcome to the World.\\n"
msgstr ""

# fuzzy message
#. sample of fuzzy message
#: lib/sample.c:355
#, fuzzy, c-format
msgid ""
"Good afternoon.\\n"
"Do you have a tea?"
msgstr ""
"こんにちは\\n"
"なにか飲む?"
EOS
    @po = GettextPo.new(@po_file)
  end
  context "シンプルなメッセージの場合、" do
    it "msgid は msgid 以下の文字列を持つ1要素の配列である" do
      @po.entry[0].msgid.should == ["Hello, World.\n"]
    end
    it "prev_msgid は #| msgid 以下の文字列を持つ1要素の配列である" do
      @po.entry[0].prev_msgid.should == ["Hello, world!!"]
    end
    it "msgstr は msgstr 以下の文字列を持つ1要素の配列である" do
      @po.entry[0].msgstr.should == ["こんにちわ、世界\n"]
    end
    it "translator_comment は # 以下の文字列である" do
      @po.entry[0].translator_comment.should == "simple message"
    end
    it "extracted_comment は #. 以下の文字列である" do
      @po.entry[0].extracted_comment.should == "sample of simple message"
    end
    it "reference は #: 以下の文字列である" do
      @po.entry[0].reference.should == "lib/sample.c:133"
    end
    it "flag は #, 以下の文字列である" do
      @po.entry[0].flag.should == "c-format"
    end
  end

  context "複数行のメッセージの場合、" do
    it "msgid は msgid 以下の文字列を持つ1要素の配列である" do
      @po.entry[1].msgid.should == ["Good-bye, World.\nSee you again."]
    end
    it "prev_msgid は #| msgid 以下の文字列を持つ1要素の配列である"
    it "msgstr は msgstr 以下の文字列を持つ1要素の配列である"
    it "translator_comment は # 以下の文字列である"
    it "extracted_comment は #. 以下の文字列である"
    it "reference は #: 以下の文字列である"
    it "flag は #, 以下の文字列である"
  end
end

describe GettextPo::Header, "は" do
  context "生成したとき" do
    
  end
end

