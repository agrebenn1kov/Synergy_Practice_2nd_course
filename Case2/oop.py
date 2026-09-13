class Animal:
    def __init__(self, name, age):
        self.name = name
        self.age = age
    
    def speak(self):
        return f"{self.name} makes a sound"
    
    def move(self):
        return f"{self.name} moves"
    
    def info(self):
        return f"Name: {self.name}, Age: {self.age} years"
    
    def __str__(self):
        return f"Animal({self.name}, {self.age})"


class Dog(Animal):
    def __init__(self, name, age, breed):
        super().__init__(name, age) 
        self.breed = breed
    
    def speak(self):  
        return f"{self.name} barks: Woof-woof!"
    
    def fetch(self):  
        return f"{self.name} fetches the stick"
    
    def info(self):  
        parent_info = super().info()
        return f"{parent_info}, Breed: {self.breed}"


class Cat(Animal):
    def __init__(self, name, age, color):
        super().__init__(name, age)
        self.color = color
    
    def speak(self): 
        return f"{self.name} meows: Meow-meow!"
    
    def climb(self): 
        return f"{self.name} climbs a tree"
    
    def info(self):
        return f"{super().info()}, Color: {self.color}"


def test_classes():
    print("=" * 50)
    print("CLASS TESTING")
    print("=" * 50)
    
    print("\n1. CREATING OBJECTS:")
    animal = Animal("Animal", 5)
    dog = Dog("Buddy", 3, "Shepherd")
    cat = Cat("Whiskers", 2, "Ginger")
    
    print(f"  {animal}")
    print(f"  {dog}")
    print(f"  {cat}")
    
    print("\n2. BASE CLASS METHODS:")
    print(f"  {animal.speak()}")
    print(f"  {animal.move()}")
    print(f"  {animal.info()}")
    
    print("\n3. OVERRIDDEN METHODS:")
    print(f"  {dog.speak()}")  
    print(f"  {cat.speak()}")  
    print(f"  {dog.move()}")   
    print(f"  {cat.move()}")   
    
    print("\n4. NEW METHODS OF DERIVED CLASSES:")
    print(f"  {dog.fetch()}")
    print(f"  {cat.climb()}")
    
    print("\n5. EXTENDED INFO() METHODS:")
    print(f"  {dog.info()}")
    print(f"  {cat.info()}")
    
    print("\n6. POLYMORPHISM (list of animals):")
    animals = [animal, dog, cat]
    for a in animals:
        print(f"  {a.speak()}") 
    
    print("\n7. TYPE CHECKING (isinstance):")
    print(f"  Is dog an Animal? {isinstance(dog, Animal)}")
    print(f"  Is dog a Dog? {isinstance(dog, Dog)}")
    print(f"  Is dog a Cat? {isinstance(dog, Cat)}")
    
    print("\n8. INHERITANCE CHECK (issubclass):")
    print(f"  Is Dog a subclass of Animal? {issubclass(Dog, Animal)}")
    print(f"  Is Cat a subclass of Animal? {issubclass(Cat, Animal)}")
    print(f"  Is Dog a subclass of Cat? {issubclass(Dog, Cat)}")
    
    print("\n9. USING super() TO CALL PARENT METHODS:")
    print(f"  {dog.info()}")  
    
    print("\n" + "=" * 50)
    print("TESTING COMPLETED")
    print("=" * 50)


if __name__ == "__main__":
    test_classes()