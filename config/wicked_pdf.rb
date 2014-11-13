binary_path = Rails.root.join('bin', 'wkhtmltopdf-amd64').to_s


WickedPdf.config = { :exe_path => binary_path }
