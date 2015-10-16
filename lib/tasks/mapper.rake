namespace :mapper do
  desc "This task exports the entire app for use or import. It includes a control file."
  task export: :environment do
    app = ActionDispatch::Integration::Session.new(Rails.application)
    Instrument.find_each do |instrument|
      app.get '/instruments/' + instrument.id.to_s + '/mapping.txt/'
      response = app.response
      print response.body
    end
  end

  desc "The task uses a control file to import data into the app."
  task import: :environment do
  end

end
