# This is a simple example of a Python class representing a library system.
class Library:
    def __init__(self, name):
        self.library_name = name
        self.books = []  # A List to store our books

    def add_book(self, book_title):
        self.books.append(book_title)
        print(f"Added: '{book_title}'")

    def show_inventory(self):
        print(f"\n--- {self.library_name} Inventory ---")
        if not self.books:
            print("The library is currently empty.")
        else:
            for index, book in enumerate(self.books, start=1):
                print(f"{index}. {book}")


my_city_library = Library("Central Tech Library")

my_city_library.add_book("Python Crash Course")
my_city_library.add_book("The Pragmatic Programmer")
my_city_library.add_book("Clean Code")
my_city_library.show_inventory()
