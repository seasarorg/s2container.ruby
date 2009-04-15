# -*- coding: utf-8 -*-
# サンプル
module Example
  class PrefectureDao
    s2comp
    s2aspect :interceptor => "dbi.interceptor"

    def find_by_dto(dto)
      return "select * from prefecture limit ? offset ?", [dto.limit, dto.offset]
    end

    def find_total_by_dto(dto)
      return "select count(*) as total from prefecture"
    end
  end
end
