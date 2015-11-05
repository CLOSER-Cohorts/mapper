module Closer
  module AddCloserCentres
    extend ActiveSupport::Concern

    included do
    end

    module ClassMethods
      def add_closer_centres(options = {})
        include Closer::AddCloserCentres::LocalInstanceMethods
      end
    end
    
    module LocalInstanceMethods
      def cls?
        return study == "CLS" || study == "BCS" || study == "MCS" || study == "NCDS"
      end
      alias cls cls?

      def soton?
        return study == "SOTON" || study == "HCS" || study == "SWS"
      end
      alias soton soton?
    end 
  end
end

ActiveRecord::Base.send :include, Closer::AddCloserCentres
