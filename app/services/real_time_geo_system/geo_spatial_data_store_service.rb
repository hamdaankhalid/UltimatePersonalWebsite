# frozen_string_literal: true

module RealTimeGeoSystem
  class GeoSpatialDataStoreService
    def initialize(db)
      @db = db
    end

    def add(params)
      validate_add(params)
      added = @db.geoadd(params[:querier_id], [params[:longitude], params[:latitude], params[:queriable_id]])
      @db.expire(params[:queriable_id], 500)
      added
    end

    def query(params)
      validate_query(params)
      @db.georadius([params[:querier_id], params[:longitude], params[:latitude], params[:radius], params[:unit]],
                    count: params[:limit], options: %w[WITHDIST WITHCOORD])
    end

    private

    def validate_add(params)
      if params.key?(:querier_id) && params.key?(:latitude) &&
         params.key?(:longitude) && params.key?(:queriable_id)
        return
      end

      raise ArgumentError,
            'Argument hash must contain querier_id, latitude, longitude, unit and queriable_id keys'
    end

    def validate_query(params)
      if params.key?(:radius) && params.key?(:querier_id) &&
         params.key?(:limit) && params.key?(:latitude) && params.key?(:longitude) && params.key?(:unit)
        return
      end

      raise ArgumentError,
            'Argument hash must contain radius, latitude, longitude, limit and querier_id keys'
    end
  end
end
