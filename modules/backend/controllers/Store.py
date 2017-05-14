from framework import Controller as std

class Store(std.Controller):

	def register(self):
		store_id = self.model(self.get_request_parameters()).save().last_id()
		return "Done: Store {} created successfully".format(store_id)

	def fetch(self):
		return self.model().find(start_from = self.get_input('start'), limit = self.get_input('limit')).fetch()

