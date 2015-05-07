#!bin/bash
#modify draw
#
sql="update draw_cash_apply set"
format="test"
		cat modify_sql.txt | awk 'substr($13,0,1)=="-" {printf "update draw_cash_apply set amount=amount%s where card_no='\''%s'\'' and date_format(create_time,'"${format}"')='\''%s'\'';\n",$13,$2,$7} substr($13,0,1)!="-" {printf "update draw_cash_apply set amount=amount+%s where card_no='\''%s'\'' and date_format(create_time,'"${format}"')='\''%s'\'';\n",$13,$2,$7}' > modify_draw_shuo.sql
