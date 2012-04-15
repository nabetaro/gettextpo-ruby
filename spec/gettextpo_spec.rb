# -*- coding: utf-8 -*-
# Copyright (C) 2011-2012 KURASAWA Nozomu (nabetaro)
# mailto: nabetaro@caldron.jp

# This Spec file is described in Japanese.

require "stringio"

$LOAD_PATH.unshift "#{File.dirname __FILE__}/../lib"
require "gettextpo"


describe GettextPo, "について" do
  context "生成したとき" do
    context "エントリがないpoファイルを渡すと" do
      before do
        @entry = StringIO.new(<<EOS)
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
      it "size == 1 である" do
        po = GettextPo.new(@entry)
        po.size.should == 1
      end
      it "entry は header のみである" do
        po = GettextPo.new(@entry)
        po.entry[0].should be_instance_of GettextPo::Header
      end
      it "rawdata は入力した生データそのものである" do
        po = GettextPo.new(@entry)
        po.rawdata.should == <<EOS
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
      it "header は GettextPo::Header のインスタンスである" do
        po = GettextPo.new(@entry)
        po.header.should be_instance_of GettextPo::Header
      end
    end
    context "1エントリのpoファイルを渡すと" do
      before do
        @entry = StringIO.new(<<EOS)
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
      it "size == 2 である" do
        po = GettextPo.new(@entry)
        po.size.should == 2
      end
      it "entry は GettextPo::Headerのインスタンス と GettextPo::Entryのインスタンスを1つ持つ配列である" do
        po = GettextPo.new(@entry)
        po.entry.should have(2).item
        po.entry[0].should be_instance_of GettextPo::Header
        po.entry[1].should be_instance_of GettextPo::Entry
        po.entry[1].msgid.should == ["Hello, World.\n"]
        po.entry[1].msgstr.should == ["こんにちわ、世界\n"]
      end
      it "rawdata は入力した生データそのものである" do
        po = GettextPo.new(@entry)
        po.rawdata.should == <<EOS
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
      it "header は GettextPo::Header のインスタンスである" do
        po = GettextPo.new(@entry)
        po.header.should be_instance_of GettextPo::Header
      end
    end
    context "2エントリのpoファイルを渡すと" do
      before do
        @entry = StringIO.new(<<EOS)
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
      it "size = 3 である" do
        po = GettextPo.new(@entry)
        po.size.should == 3
      end
      it "entry は GettextPo::Headerのインスタンス と GettextPo::Entryのインスタンスを2つ持つ配列である" do
        po = GettextPo.new(@entry)
        po.entry.should have(3).items
        po.entry[0].should be_instance_of GettextPo::Header
        po.entry[1].should be_instance_of GettextPo::Entry
        po.entry[1].msgid.should == ["Hello, World.\n"]
        po.entry[1].msgstr.should == ["こんにちわ、世界\n"]
        po.entry[2].should be_instance_of GettextPo::Entry
        po.entry[2].msgid.should == ["Good-bye, World.\nSee you again."]
        po.entry[2].msgstr.should == ["さよなら、世界\nまた会う日まで"]
      end
      it "rawdata は入力した生データそのものである" do
        po = GettextPo.new(@entry)
        po.rawdata.should == <<EOS
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
      it "header は GettextPo::Header のインスタンスである" do
        po = GettextPo.new(@entry)
        po.header.should be_instance_of GettextPo::Header
      end
    end
  end

end

describe GettextPo::Entry, "について" do
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

# multiline message.
# second line.
#. sample of multiline message
#. second line.
#: lib/sample.c:255
#: lib/sample2.c:155
#, c-format
#| msgid "Good-bye, World.\\n"
#| "See you later."
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
      @po.entry[1].msgid.should == ["Hello, World.\n"]
    end
    it "prev_msgid は #| msgid 以下の文字列を持つ1要素の配列である" do
      @po.entry[1].prev_msgid.should == ["Hello, world!!"]
    end
    it "msgstr は msgstr 以下の文字列を持つ1要素の配列である" do
      @po.entry[1].msgstr.should == ["こんにちわ、世界\n"]
    end
    it "translator_comment は # 以下の文字列である" do
      @po.entry[1].translator_comment.should == "simple message"
    end
    it "extracted_comment は #. 以下の文字列である" do
      @po.entry[1].extracted_comment.should == "sample of simple message"
    end
    it "reference は #: 以下の文字列である" do
      @po.entry[1].reference.should == "lib/sample.c:133"
    end
    it "flag は #, 以下の文字列を','で区切った配列である" do
      @po.entry[1].flag.should == ["c-format"]
    end
    it "raw は エントリ全体の生文字列である" do
      @po.entry[1].raw.should == <<EOS
# simple message
#. sample of simple message
#: lib/sample.c:133
#, c-format
#| msgid "Hello, world!!"
msgid "Hello, World.\\n"
msgstr "こんにちわ、世界\\n"
EOS
    end
  end

  context "複数行のメッセージの場合、" do
    it "msgid は msgid 以下の文字列を持つ1要素の配列である" do
      @po.entry[2].msgid.should == ["Good-bye, World.\nSee you again."]
    end
    it "prev_msgid は #| msgid 以下の文字列を持つ1要素の配列である" do
      @po.entry[2].prev_msgid.should == ["Good-bye, World.\nSee you later."]
    end
    it "msgstr は msgstr 以下の文字列を持つ1要素の配列である" do
      @po.entry[2].msgstr.should == ["さよなら、世界\nまた会う日まで"]
    end
    it "translator_comment は # 以下の文字列である" do
      @po.entry[2].translator_comment.should == "multiline message.\nsecond line."
    end
    it "extracted_comment は #. 以下の文字列である" do
      @po.entry[2].extracted_comment.should == "sample of multiline message\nsecond line."
    end
  end
end

describe GettextPo::Header, "について" do
  before do
    @entry = StringIO.new(<<EOS)
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
EOS
  end

  it "project_id_version は Project-Id-Version: にある値である" do
    po = GettextPo.new(@entry)
    po.header.project_id_version.should == "sample_app 0.0.1"
  end
  it "report_msgid_bugs_to は Report-Msgid-Bugs-To: にある値である" do
    po = GettextPo.new(@entry)
    po.header.report_msgid_bugs_to.should == ""
  end
  it "pot_creation_date は POT-Creation-Date: にある値をDateTimeクラスにした値である" do
    po = GettextPo.new(@entry)
    po.header.pot_creation_date.should == DateTime.parse("2011-01-01 12:34+0900")
  end
  it "po_revision_date は PO-Revision-Date: にある値をDateTimeクラスにした値である" do
    po = GettextPo.new(@entry)
    po.header.po_revision_date.should == DateTime.parse("2011-01-11 13:57+0900")
  end
  it "last_translator は Last-Translator: にある値である" do
    po = GettextPo.new(@entry)
    po.header.last_translator.should == "KURASAWA Nozomu <nabetaro@example.com>"
  end
  it "language_team は Language-Team にある値である" do
    po = GettextPo.new(@entry)
    po.header.language_team.should == "Example Team <team@example.com>"
  end
  it "language は Language: にある値である" do
    po = GettextPo.new(@entry)
    po.header.language.should == "ja_JP"
  end
  it "content_type は Content-Type: にある値である" do
    po = GettextPo.new(@entry)
    po.header.content_type.should == "text/plain; charset=UTF-8"
  end
  it "content_transfer_encoding は Content-Transfer-Encoding: にある値である" do
    po = GettextPo.new(@entry)
    po.header.content_transfer_encoding.should == "8 bit"
  end
  it "plural_forms は Plural-Forms: にある値である" do
    po = GettextPo.new(@entry)
    po.header.plural_forms.should == nil
  end
end

