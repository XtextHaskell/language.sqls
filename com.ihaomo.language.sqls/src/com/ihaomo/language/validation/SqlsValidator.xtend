/*
 * generated by Xtext
 */
package com.ihaomo.language.validation
import org.eclipse.xtext.validation.Check
import com.ihaomo.language.sqls.SqlType
import com.ihaomo.language.types.PrimitiveType
import com.ihaomo.language.sqls.SqlsPackage
import com.ihaomo.language.types.ParametedType
import com.ihaomo.language.sqls.SqlFunction

/**
 * Custom validation rules. 
 *
 * see http://www.eclipse.org/Xtext/documentation.html#validation
 */
class SqlsValidator extends AbstractSqlsValidator {

  public static val INVALID_TYPE = 'invalidType'
  public static val INVALID_FUNCTION_CALL = "invalidFunction"

	@Check
	def checkSqlType(SqlType sqlType) {
		switch (t : sqlType.type) {
			ParametedType : {
				val num1 = t.paramTypes.size
				val num2 = sqlType.params.size
				if (num1 != num2) 
					error('''Parameted Type «t.name» need «num1» params, but have «num2» params''',
						SqlsPackage.Literals.SQL_TYPE__TYPE, INVALID_TYPE
					)
			}
			default : {
				if (!sqlType.params.empty) 
					error("Only Parameted Type can have params",
						SqlsPackage.Literals.SQL_TYPE__TYPE, INVALID_TYPE
					)
			}
		}
	}
	
	@Check
	def checkSqlFunction(SqlFunction it) {
		switch (f : function) {
			case f.varArgs : {
				if (f.paramTypes.size > params.size) {
					error('''function «f.name» need at least «f.paramTypes.size» params'''
						,SqlsPackage.Literals.SQL_FUNCTION__FUNCTION, INVALID_FUNCTION_CALL
					)
				}
			}
			case f.paramTypes.size != params.size : {
				error('''function «f.name» need «f.paramTypes.size» params, but have «params.size» params'''
						,SqlsPackage.Literals.SQL_FUNCTION__FUNCTION, INVALID_FUNCTION_CALL
					)
			}
		}
	}
}
