require 'latex_flags'
require 'latex_wiki_page'

class DocPuWikiPage < ActiveRecord::Base
  unloadable

  belongs_to :wiki_page
  belongs_to :doc_pu_document
  validates_presence_of :wiki_page_id, :doc_pu_document_id
  
  after_initialize :load_flags
  before_save :save_flags
  
  include ModuleLatexFlags
  include ModuleLatexWikiPage

  def to_latex()
    self.chapter_name = (self.chapter_name != "" ? self.chapter_name : self.wiki_page.title)
    # Get document flags
    if self.use_doc_flags && !self.doc_pu_document.nil?
      ModuleLatexFlags::FLAGS.each do |m, v|
        self.send(m.to_s + "=", self.doc_pu_document.send(m))
      end
    end
    super
  end
  
  def load_flags()
    self.flags_from_str(self.flags)
    return true
  end

  def save_flags()
    self.flags = self.flags_to_str()
    return true
  end

end
