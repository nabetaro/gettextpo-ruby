# -*- coding: utf-8 -*-
# Copyright (C) 2011 KURASAWA Nozomu (nabetaro)
# mailto: nabetaro@caldron.jp
#
# This Class describe GNU Gettext PO format file. see also:
#  http://www.gnu.org/software/gettext/manual/gettext.html#PO-Files

require 'strscan'

#= Class library for handling gettext po file.
class GettextPo
  class InvalidEntry < StandardError; end

  #== One entry
  class Entry
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

    def header?
      @header_flag
    end

    def msgid
      @msgid
    end

    def prev_msgid
      @prev_msgid
    end

    def msgstr
      @msgstr
    end

    def translator_comment
      @translator_comment
    end

    def extracted_comment
      @extracted_comment
    end

    def reference
      @reference
    end

    def flag
      @flag
    end

    def raw
      @raw
    end

    def unescape(str)
      str.gsub(/\\n/, "\n")
    end
    private :unescape
  end

  class Header < Entry
    def initialize(lines)
      super lines
      @header_flag = true
    end
  end

  # _
  def initialize(src, opt={})
    @src = src.is_a?(String) ? StringIO.new(src) : src
    @rawdata = ""
    @header = nil
    @entries = []
    parse
  end

  attr_reader :rawdata

  def size
    @entries.size
  end

  def entry
    @entries
  end

  def header
    @header
  end

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
