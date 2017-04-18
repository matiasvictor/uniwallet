from framework import Treater as std

class User(std.Treater):
	def register(self):
		return self.rules({
				"fields": {
					"firstname": ["required"],
					"lastname": ["required"],
					"email": ["required"],
					"university": ["required"],
					"password": ["required"]
				},
				"method": "get"
				#"auth": ["manager", "client"]
			})



