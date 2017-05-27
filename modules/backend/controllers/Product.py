from framework import Controller as std

class Product(std.Controller):

	def register(self):
		product_id = self.model(self.get_request_parameters()).save().last_id()
		price = self.get_model('Product_Price', data = {'product_id': product_id, 'price': self.get_input('price')}).save().close()
		return "Done: Store {} created successfully".format(product_id)

	def fetch(self):
		return (self.model().find(join=[('Company', 'company_id')], start_from = self.get_input('start'), limit = self.get_input('limit'))
			.fetch(fields_mask = [('name', 'Nome'), ('price', 'Preço'), ('company_name', 'Empresa'), ('description', 'Descrição')]))



