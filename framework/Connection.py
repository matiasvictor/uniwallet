from helpers import dictionary
"""
Just Models use that class
"""
class Connection:
	def __init__(self, connection, cursor):
		self.connection = connection
		self.cursor = cursor

	def close(self):
		"""
		close(): It closes both cursor and database connection
		"""
		self.cursor.close()
		self.connection.close()

	def fetch(self, fields = [], fields_to_ignore = [], close_connection = True, fields_mask = []):
		"""
		fetch(): It returns a list of dict from the got data
		"""
		raw_records = self.cursor.fetchall()
		records = []
		for record_tuple in raw_records:
			data = dictionary.remove_fields(dict(zip(self.cursor.column_names, record_tuple)), fields_to_ignore)
			if len(fields) > 0:
				data = dictionary.select(data, fields)
			if len(fields_mask) > 0:
				data = dictionary.mask(data, fields_mask)
			records.append(data)
		if close_connection:
			self.close()
		return records

	def fetchone(self, fields = [], fields_to_ignore = [], close_connection = True, fields_mask = []):
		"""
		fetchone(): It returns a single record from the DB
		"""
		raw_record = self.cursor.fetchone()
		record = None
		if raw_record is not None:
			record = dictionary.remove_fields(dict(zip(self.cursor.column_names, raw_record)), fields_to_ignore)
			if len(fields) > 0:
				record = dictionary.select(record, fields)
			if len(fields_mask) > 0:
				record = dictionary.mask(record, fields_mask)
		if close_connection:
			self.close()
		return record

	def get_cursor_attr(self, attr_name, close_connection):
		"""
		get_cursor_attr(): It gets a cursor attribute
		"""
		attr = getattr(self.cursor, attr_name, None)
		if close_connection:
			self.close()
		return attr

	def count_rows(self, close_connection = True):
		"""
		count_rows(): It gets the rowcount of the transaction
		"""
		return self.get_cursor_attr(attr_name = "rowcount", close_connection = close_connection)

	def last_id(self, close_connection = True):
		"""
		last_id(): It gets last of the transaction
		"""
		return self.get_cursor_attr(attr_name = "lastrowid", close_connection = close_connection)