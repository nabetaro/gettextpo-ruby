# -*- coding: utf-8 -*-
# Copyright (C) 2011-2012 KURASAWA Nozomu (nabetaro)
# mailto: nabetaro@caldron.jp
#
# This Class describe GNU Gettext PO format file. see also:
#  http://www.gnu.org/software/gettext/manual/gettext.html#PO-Files

require 'strscan'

#= Class library for handling gettext po file.
class GettextPo
  #=== エントリ内に想定外の構造があった場合の例外
  class InvalidEntry < StandardError; end

  #== GetText poファイルの1エントリを表すクラス
  class Entry
    #=== 初期化
    # 1エントリを表す文字列を元に、各要素を解析して格納する
    #_lines_:: 1エントリを表す複数行の文字列
    def initialize(lines)
      s = StringScanner.new lines
      @raw = lines
      @translator_comment = ""      # translator-comments
      @extracted_comment = ""       # extracted-comments
      @reference = ""               # reference
      @flag = ""                    # flag
      @prev_msgid = [""]            # previous-untranslated-string
      @msgid = [""]                 # untranslated-string
      @msgstr = [""]                # translated-string
      @header_flag = false
      while !s.eos?
        if s.scan(/^#\. ?(.*)\n/)
          # extracted-comments
          @extracted_comment << s[1]
        elsif s.scan(/^#\: ?(.*)\n/)
          # reference
          @reference << s[1]
        elsif s.scan(/^#\, ?(.*)\n/)
          # flag
          @flag << s[1]
        elsif s.scan(/^#\| msgid \"(.*)\"\n/)
          # previous-untranslated-string
          @prev_msgid[0] = ""  unless @prev_msgid[0]
          @prev_msgid[0] << unescape(s[1])
          while s.scan(/^#\| \"(.*)\"\n/)
            @prev_msgid[0] << unescape(s[1])
          end
        elsif s.scan(/^msgid \"(.*)\"\n/)
          # untranslated-string
          @msgid[0] = ""  unless @msgid[0]
          @msgid[0] << unescape(s[1])
          while !s.scan(/^\"(.*)\"\n/).nil?
            @msgid[0] << unescape(s[1])
          end
        elsif s.scan(/^msgid_plural \"(.*)\"\n/)
          # untranslated-string
          @msgid[1] = ""  unless @msgid[1]
          @msgid[1] << unescape(s[1])
          while !s.scan(/^\"(.*)\"\n/).nil?
            @msgid[1] << unescape(s[1])
          end
        elsif s.scan(/^msgstr(\[(\d+)\])* \"(.*)\"\n/)
          # translated-string
          i = s[2] ? s[2].to_i : 0
          @msgstr[i] = ""  unless @msgstr[i]
          @msgstr[i] << unescape(s[3])
          while !s.scan(/^\"(.*)\"\n/).nil?
            @msgstr[i] << unescape(s[1])
          end
        elsif s.scan(/^# ?(.*)\n/)
          # translator-comments
          @translator_comment << s[1]
        elsif s.scan(/\s*\n/)
          nil
        else
          raise InvalidEntry, "REST: #{s.rest}"
        end
        @header_flag = true if @msgid[0].empty?
      end
    end

    #=== ヘッダかどうか表す
    def header?
      @header_flag
    end

    #=== 翻訳元文字列
    def msgid
      @msgid
    end

    #=== 以前の翻訳元文字列
    def prev_msgid
      @prev_msgid
    end

    #=== 翻訳文字列
    def msgstr
      @msgstr
    end

    #=== 翻訳コメント
    def translator_comment
      @translator_comment
    end

    #=== 抽出コメント
    def extracted_comment
      @extracted_comment
    end

    #=== 参照
    def reference
      @reference
    end

    #=== フラグ
    def flag
      @flag
    end

    #=== エントリの生文字列
    def raw
      @raw
    end

    #=== 翻訳文字列内のエスケープ文字をアンエスケープする
    #_str_:: エスケープ文字列
    def unescape(str)
      str.gsub(/\\n/, "\n")
    end
    private :unescape
  end

  #== エントリのうち先頭にあるヘッダ部
  class Header < Entry
    #=== 初期化
    # Entry を生成後、msgstr内の各タグを解析する
    #_lines_:: 1エントリを表す複数行の文字列
    def initialize(lines)
      super lines
      @header_flag = true
    end
  end

  #=== 初期化する
  #_src_:: IOクラスのインスタンス
  #_opt_:: オプション(今は動作しない)
  def initialize(src, opt={})
    @src = src.is_a?(String) ? StringIO.new(src) : src
    @rawdata = ""
    @header = nil
    @entries = []
    parse
  end

  #=== poファイルの生データ
  attr_reader :rawdata

  #=== エントリ数
  # エントリ配列の要素数
  def size
    @entries.size
  end

  #=== エントリ配列
  # 先頭要素は GettextPo::Header のインスタンス
  # それ以降は GettextPo::Entry のインスタンス
  def entry
    @entries
  end

  #=== ヘッダエントリ
  # GettextPo::Header のインスタンス
  def header
    @header
  end

  #=== poファイルをパースする
  # poファイル内を空行で区切り1エントリとする
  # 先頭のエントリをヘッダとみなす
  def parse
    buf = ""
    while line = @src.gets
      @rawdata << line
      if line =~ /\A\s*\z/
        if @header.nil? and @entries.empty?
          @header = Header.new(buf)
          @entries << @header
        else
          @entries << Entry.new(buf)
        end
        buf = ""
      else
        buf << line
      end
    end
    unless buf.empty?
      if @header.nil? and @entries.empty?
        @header = Header.new(buf)
        @entries << @header
      else
        @entries << Entry.new(buf)
      end
    end
  end
  private :parse


end
