require 'redcloth'

module RedCloth::Formatters::LATEX_EX
    include RedCloth::Formatters::LATEX
    
    def arrow(opts)
        "$\\rightarrow$"
    end
    
    # inline code
    #~ def code(opts)
        #~ opts[:block] ? opts[:text] : opts[:text].gsub!('&nbsp;', ' ')
        #~ opts[:block] ? opts[:text] : "\\verb@#{opts[:text]}@"
    #~ end
    
    def td(opts)
        if not opts[:text].nil? and not opts[:text].index(/\n/).nil?
            opts[:text].gsub!(/\n/, ' \\newline ')
        end
        opts[:text] = "\\textbf{#{opts[:text]}}" unless opts[:th].nil?
        column = @table_row.size
        if opts[:colspan]
            vline = (draw_table_border_latex ? "|c|" : "c")
            opts[:text] = "\\multicolumn{#{opts[:colspan]}}{#{vline}}{#{opts[:text]}}"
        end
        if opts[:rowspan]
            @table_multirow_next[column] = opts[:rowspan].to_i - 1
            opts[:text] = "\\multirow{#{opts[:rowspan]}}{*}{#{opts[:text]}}"
        end
        @table_row.push(opts[:text])
        return ""
    end
    
    def table_open(opts)
        @table = []
        @table_multirow = {}
        @table_multirow_next = {}
       puts opts[:id]
        return ""
    end

    def table_close(opts)
        maxlen = 0
        @table.each do |row|
          if maxlen < row.size
            maxlen = row.size
          end
        end
        output  = "\\begin{table}[H]\n"
        output << "  \\centering\n"
        cols = "l" if not draw_table_border_latex
        cols = "|l|" if draw_table_border_latex
        cols += "J" * (maxlen-1) if not draw_table_border_latex
        cols += "J|" * (maxlen-1) if draw_table_border_latex
        output << "  \\begin{tabulary}{\\linewidth}{#{cols}}\n"
        output << "   \\hline \n" if draw_table_border_latex
        @table.each do |row|
            hline = (draw_table_border_latex ? "\\hline" : "")
            output << "    #{row.join(" & ")} \\\\ #{hline} \n"
        end
        output << "  \\end{tabulary}\n"
        output << "\\end{table}\n"
        output
    end

    def image(opts)
        opts[:alt] = opts[:src]
        # Don't know how to use remote links, plus can we trust them?
        return "" if opts[:src] =~ /^\w+\:\/\//
        # Resolve CSS styles if any have been set
        styling = opts[:class].to_s.split(/\s+/).collect { |style| latex_image_styles[style] }.compact.join ','
                styling += "width=\\textwidth"
        # Build latex code
        [ "\\begin{figure}[#{(opts[:align].nil? ? "H" : "htb")}]",
          "  \\centering",
          "  \\includegraphics[#{styling}]{#{opts[:src]}}",
         ("  \\caption{#{escape opts[:title]}}" if opts[:title]),
         ("  \\label{#{opts[:alt]}}" if opts[:alt]),
          "\\end{figure}",
        ].compact.join "\n"
    end
    
end

module RedClothExtensionLatex

    def latex_code(text)
        text.gsub!(/<pre>(.*?)<\/pre>/im) do |m|
            code = $1
            code.match(/<code\s+class="(.*)">(.*)<\/code>/im)
            lang = "{}"
            unless $1.nil?
                code = $2
                lang = "{#{$1}}"
            end
            "<notextile>\\begin{lstlisting}[language=#{lang}]#{code}\\end{lstlisting}\n</notextile>"
        end
    end

    def latex_page_ref(text)
        text.gsub!(/(\s|^)\[\[(.*?)(\|(.*?)|)\]\]/i) do |m|
            var = $2
            label = $4
            "<notextile> #{label} \\ref{page:#{var}}</notextile>"
        end
    end

    def latex_image_ref(text)
        text.gsub!(/(\s|^)\{\{!(.*?)!\}\}/i) do |m|
            var = $2
            "<notextile> \\ref{#{var}}</notextile>"
        end
    end

    def latex_footnote(text)
        notes = {}
        # Extract and delete footnote 
        text.gsub!(/fn(\d+)\.\s+(.*)/i) do |m| 
            notes[$1] = $2      
            "" 
        end
        # Add footnote
        notes.each do |fn, txt|
            text.gsub!(/(\w+)\[#{fn}\]/i) do |m|
                "<notextile>#{$1}\\footnote{#{txt}}</notextile>" 
            end
        end
    end

    def latex_index_emphasis(text)
        text.gsub!(/\s_(\w.*?)_/im) do |m|
            var = $1
            " <notextile>\\index{#{var}}</notextile> _#{var}_"
        end
    end

    def latex_index_importance(text)
        text.gsub!(/\s\*(\w.*?)\*/im) do |m|
            var = $1
            " <notextile>\\index{#{var}}</notextile> *#{var}*"
        end
    end

    def latex_remove_macro(text)
        text.gsub!(/(\s|^)\{\{(.*?)\}\}/i) do |m|
        ""
        end
    end
end


class TextileDocLatex < RedCloth::TextileDoc
    attr_accessor :draw_table_border_latex
    
    def to_latex( *rules )
        apply_rules(rules)
        to(RedCloth::Formatters::LATEX_EX)
    end
end

# Include rules
RedCloth.include(RedClothExtensionLatex)
