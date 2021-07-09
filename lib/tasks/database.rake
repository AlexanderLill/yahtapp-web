namespace :database do
  desc "Resets the postgres sequence for each table (required after import of prod data)"
  task correction_seq_id: :environment do
    ActiveRecord::Base.connection.tables.each do |t|
      ActiveRecord::Base.connection.reset_pk_sequence!(t)
    end
  end

end
