# -*- coding: utf-8 -*-
# Copyright (C) 2011 KURASAWA Nozomu (nabetaro)
# mailto: nabetaro@caldron.jp

# This Spec file is described in Japanese.

require "stringio"

$LOAD_PATH.unshift "#{File.dirname __FILE__}/../lib"
require "gettextpo"

describe GettextPo, "は" do
  context "new するとき" do
    context "エントリがないpoファイルを渡すと" do
      before do
        @po_file = StringIO.new(<<EOS)
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
        po = GettextPo.new(@po_file)
        po.size.should == 0
      end
      it "entry は empty である" do
        po = GettextPo.new(@po_file)
        po.entry.should be_empty
      end
    end
    context "1エントリのpoファイルを渡すと" do
      before do
        @po_file = StringIO.new(<<EOS)
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
        po = GettextPo.new(@po_file)
        po.size.should == 1
      end
      it "entry は GettextPo::Entryのインスタンスを1つ持つ配列である" do
        po = GettextPo.new(@po_file)
        po.entry.should have(1).item
        po.entry[0].should be_instance_of GettextPo::Entry
        po.entry[0].msgid.should == ["Hello, World.\n"]
        po.entry[0].msgstr.should == ["こんにちわ、世界\n"]
      end
    end
    context "2エントリのpoファイルを渡すと" do
      before do
        @po_file = StringIO.new(<<EOS)
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
        po = GettextPo.new(@po_file)
        po.size.should == 2
      end
      it "entry は GettextPo::Entryのインスタンスを2つ持つ配列である" do
        po = GettextPo.new(@po_file)
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
    it "GettextPo::Header のインスタンスである" do
      @po_file = StringIO.new(<<EOS)
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
      po = GettextPo.new(@po_file)
      po.header.should be_instance_of GettextPo::Entry
      po.header.header?.should be_true
    end
  end

end

describe GettextPo::Entry, "は" do
  context "new したとき" do
    it "translator_comment は "
  end
end

# describe GettextPo::Header, "は" do
#   context "new したとき" do
    
#   end
# end

