package vn.cineman.model;
import java.math.BigDecimal;import java.time.LocalDateTime;import java.util.Map;
public record Show8(long id,long roomId,LocalDateTime startsAt,BigDecimal price) {
 public static Show8 from(Map<String,Object> row){return new Show8(((Number)row.get("id")).longValue(),((Number)row.get("room_id")).longValue(),(LocalDateTime)row.get("starts_at"),(BigDecimal)row.get("price"));}
}
