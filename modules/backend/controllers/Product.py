from . import Controller as std

class Product(std.Controller):

	def register(self):
		product_id = self.model(data = self.get_request_parameters()).save().last_id()
		price = self.model(name = 'Product_Price', data = {'product_id': product_id, 'price': self.get_input('price')}).save().close()
		return "Done: Store {} created successfully".format(product_id)

	def fetch(self):
		return (self.model().find(join=[('Company', 'company_id')], start_from = self.get_input('start'), limit = self.get_input('limit'))
			.fetch())

	def fetchadmin(self):
		mask = self.metadata([('id', 'id:::'), ('quantity', ':Quantidade'), ('name', ':Nome'), ('description', ':Descrição'), ('category', ':Categoria'), ('price', ':Preço'), ('company_id', ':Empresa:Company'), ('company_name', ':Empresa::noneditable')])
		return (self.model().find(join=[('Company', 'company_id')], start_from = self.get_input('start'), limit = self.get_input('limit'))
			.fetch(fields_mask = mask))

	def fetchall(self):
		mask = self.metadata([('id', 'id:::'), ('quantity', ':Quantidade'), ('name', ':Nome'), ('description', ':Descrição'), ('category', ':Categoria'), ('price', ':Preço'), ('company_id', ':Empresa:Company'), ('company_name', ':Empresa::noneditable')])
		return (self.model().find(join=[('Company', 'company_id')], start_from = self.get_input('start'), limit = self.get_input('limit'))
			.fetch(fields_mask = mask))

	def categoryfilter(self):
		filtercategory = []
		product_filter = self.model().find().fetch()
		for product in product_filter:
			filtercategory.append({'Product':product,'Category':self.model(name = 'Product').find([('category','=',product['category'])]).fetch()})
		return filtercategory


	def show_all(self):
		
		#user_id = self.model(name = 'Session').get_user()['id']
		#company = self.model("Company").find([('user_id', '=', 1)]).fetchone("id")["id"]
		#return self.model("Product").find(conditions = [("company_id", '=', company)], join = [("Company", "company_id")]).fetch()
		return self.model("Product").find(join = [("Company", "company_id")]).fetch()

	def show_x(self):
		company = str(self.get_input("company"))
		#user_id = self.model(name = 'Session').get_user()['id']
		#company = self.model("Company").find([('user_id', '=', 1)]).fetchone("id")["id"]
		#return self.model("Product").find(conditions = [("company_id", '=', company)], join = [("Company", "company_id")]).fetch()
		return self.model("Product").find(conditions = [("company_id", '=', company)], join = [("Company", "company_id")]).fetch()