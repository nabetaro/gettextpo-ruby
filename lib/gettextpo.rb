# -*- coding: utf-8 -*-
# Copyright (C) 2011 KURASAWA Nozomu (nabetaro)
# mailto: nabetaro@caldron.jp
#
# This Class describe GNU Gettext PO format file. see also:
#  http://www.gnu.org/software/gettext/manual/gettext.html#PO-Files

class GettextPo

  class Entry
    def initialize(lines)

      @translator_comment = []        # translator-comments
      @extracted_comment = []       # extracted-comments
      @reference = []               # reference
      @flag = []
      @prev_msgid = ""
      @msgid = ""
      @msgstr = ""
      @header_flag = false
      lines.each do |l|
#        p l
        if l =~ /\A\# (.*)\z/
          # translator-comments
          @translator_comment << $1
        elsif l =~ /\A#\. (.*)\Z/
          # extracted-comments
          @extracted_comment << $1
        elsif l =~ /\A#\: (.*)\Z/
          # reference
        elsif l =~ /\A#\, (.*)\Z/
          # flag
        elsif l =~ /\A#\| msgid \"(.*)\"\Z/
          # previous-untranslated-string
          @prev_msgid << $1
          @prev_msgid << "\n" if $2
        elsif l =~ /\Amsgid \"(.*)\"\Z/
          # untranslated-string
p $1
          @msgid << $1
          p @msgid
        elsif l =~ /\Amsgstr \"(.*)\"\Z/
          @msgstr << $1
          # translated-string
        elsif l =~ /\A\"(.*)\"\Z/
          
        end
        @header_flag = true if @msgid.empty?
      end
    end

    def header?
      @header_flag
    end

    def msgid
      @msgid
    end

    def msgstr
      @msgstr
    end
  end

  def initialize(src, opt={})
    @src = src.is_a?(String) ? StringIO.new(src) : src
    @header = nil
    @entries = []
    parse
  end

  def size
    @entries.size
  end

  def entry
    @entries
  end


  def parse
    buf = []
    while line = @src.gets
      buf << line
      if line =~ /\A\s*\z/
        e = Entry.new(buf)
        if @header.nil? and e.header?
          @header = e
        else
          @entries << e
        end
        buf = []
      end
    end
    e = Entry.new(buf)
    if @header.nil? and e.header?
      @header = e
    else
      @entries << e
    end
  end
  private :parse


end
