class Activity {
  final String name;
  final String image;
  final String description;
  final int price;

  Activity({
    required this.name,
    required this.image,
    required this.description,
    required this.price,
  });
}

List<Activity> activities = [
  Activity(
    name: 'House Cleaning',
    image: 'images/home cleanning.jpeg',
    description: 'Service at Home',
    price: 49,
  ),
  Activity(
    name: 'Car Cleaning',
    image: 'images/carcleaning.jpg',
    description: 'Service at Home',
    price: 149,
  ),
  Activity(
    name: 'Pest control',
    image: 'images/home cleanning.jpeg',
    description: 'Service at Home',
    price: 149,
  ),
  Activity(
    name: 'Barber',
    image: 'iimages/barber.jpg',
    description: 'Free Waxing',
    price: 69,
  ),
  Activity(
    name: 'Electrician',
    image: 'images/carcleaning.jpg',
    description: 'Service at Home',
    price: 100,
  ),
  Activity(
    name: 'Plumber',
    image: 'images/Plumber.jpeg',
    description: 'Service at Home',
    price: 79,
  ),
  Activity(
    name: 'Painting',
    image: 'images/painting.jpeg',
    description: 'Service at Home',
    price: 69,
  ),
  Activity(
    name: 'Carpenter',
    image: 'images/Carpenter.jpeg',
    description: 'Service at Home',
    price: 79,
  ),
  Activity(
    name: 'AC Services',
    image: 'images/AC Services.jpeg',
    description: 'Service at Home',
    price: 70,
  ),
  // Add more activities here...
];