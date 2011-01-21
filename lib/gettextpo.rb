# -*- coding: utf-8 -*-
# Copyright (C) 2011 KURASAWA Nozomu (nabetaro)
# mailto: nabetaro@caldron.jp
#
# This Class describe GNU Gettext PO format file. see follow:
#  http://www.gnu.org/software/gettext/manual/gettext.html#PO-Files

class GettextPo

  class Entry
    def initialize

      @translator_comment = ""        # translator-comments
      @extracted_comment = ""       # extracted-comments
      @reference = ""               # reference
      @flag = nil
      @prev_msgid = ""
      @msgid = ""
      @msgstr = ""
    end


  end

  class Header
  end

  def initialize(src, opt={})
    @src = src.is_a?(String) ? StringIO.new(src) : src
    @entries = []
  end

  def size
    @entries.size
  end

  def entry
    @entries
  end


  def parse
    
  end
  private :parse

end
