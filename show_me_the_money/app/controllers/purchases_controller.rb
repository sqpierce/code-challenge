require 'csv'

# Note: rather than a purchases controller (which might be reserved for a REST-based view of purchases),
#       we could have created a DataFile model (and controller), and saved data file info to the db.
#       This would have facilitated a mechanism for avoiding duplicate file uploads,
#       and given a way for purchases to be traced back to their origin (file).
#       Am considering this beyond the scope of this exercise.

class PurchasesController < ApplicationController

  def datafile
    if request.post?
      #binding.pry
      begin
        #throw # testing
        #data = CSV.read(params['datafile'].tempfile.path, { :col_sep => "\t" })
        # testing without tempfile method for rspec
        data = CSV.read(params['datafile'].path, { :col_sep => "\t" })
      rescue # just in case there's an issue reading file
        render :file => 'public/500.html', :status => :internal_server_error, :layout => false
        return
      end
      # assume file data is valid according to instructions
      sum_of_purchases = Purchase.parse_data(data)
      flash[:notice] = "Successfully recorded #{view_context.number_to_currency(sum_of_purchases)}. Well done!"
      redirect_to datafile_path
    end
  end
  
end

