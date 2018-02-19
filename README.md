<h1>salesman</h1>
<h2>Knock! Knock! (Knock!) - Who's there? - Travelling Salesman Problem (TSP)</h2>
<h3>Why?</h3>
<p>I always wanted to learn Genetic Algorithm (GA) approach and always thought it is fascinating. So we started with gronki a project 'evolenses' which is about using GA to design a telescope that has certain properties (just gives <strong>ANY</strong> image, achromat, apochromat etc.). However, it was too hard for me to tackle at once problem of GA and a problem of designing a telescope. </p>
<p>To do one thing at a time I decided to find a problem that is easy to implement and will let me deal just with GA. </p>
<h3>About TSP</h3>
<p>The problem is to visit N places with the optimal path (shortest, quickest, longest etc. - depending on a specific problem). As one can easily show, there are N! possibilities so even for N within a range of 20 the problem cannot be solved by brute force. Since GA is commonly used to optimization and TSP is quite easy to implement, TSP seems suited perfectly to learn GA.</p>
<p>If you want to learn more about this problem,  you can read more in: </p>
<ul>
  <li>general information - https://en.wikipedia.org/wiki/Travelling_salesman_problem</li>
  <li>a tutorial that helped me to start - https://www.tutorialspoint.com/genetic_algorithms/<br>
  I applied all general methods and algorithms from this website to my particular TSA problem</li>
</ul>

<h2>What is my problem?</h2>
<p>I love to travel. I've visited many countries in Europe and I happened to be in the southwest USA, I've road-tripped along Chile, I've seen Japan - plan to see a lot more including New Zealand. But the time is finite and the question is: how to travel in the optimal way to see everything, instead of bouncing around.</p>
<p>My problem is the following: given a set of N capital cities (of a given continent, continents or the whole world) I want to find the shortest path that covers all capital cities.</p>

<h2>Technical details of the project</h2>
<p>In this subsection, I will describe the theoretical background for the project and why I did things that I did.</p>

<h3>Data</h3>
<p>The data (the list of capitals with their coordinates) was obtained from the following sites:
  <ul>
    <li><a href="http://www.tripmondo.com/magazine/facts-and-statistics/list-of-capitals-and-countries/">www.tripmondo.com</a></li>
    <li><a href="http://www.xfront.com/us_states/">www.xfront.com</a>.</li>
  </ul>
  Latitudes and longitudes was transformed to radians for the convenience.
</p>

<h3>Chromosome</h3>
<p>A chromosome is a set of properties of one realization &mdash; here a sequence of N capitals visited. There are as many possibilities as there are permutations. </p>

<h3>Fitness function</h3>
<p>Fitness function is a function that is optimized (maximized or minimized). For the TSP a natural choice is the total length of the path. If we choose our path in not a very clever way and would zig-zag back and forth, the total distance covered would be large. If we choose our path in a clever way, then the total distance would be smaller. Note, that our choice of a fitness function is not unique and we can obtain another fitness function for example by using a monotonic function of the total distance function.</p>

<h3>Breeding</h3>

<h4>Parent selection</h4>
<p>The parents are selected with the so-called Roulette Wheel Selection method. Each chromosome has a chance to be selected proportional to its fitness. This way the best fitness, the higher chance to survive to the next generation.</p>

<h4>Crossover</h4>
<p>A very important mechanism of evolution is mixing the properties of parents which boosts the adaptation when comparing it with mere random mutations which are usually negative. Negative mutations means that the new organism is not fit enough to survive and it dies. In the language of our problem a negative mutation path will be very long and will be canceled quickly. There is not a unique way to mix two different permutations and produce a hybrid permutations. Here, the following method is implemented: Davis' Order Crossover (O1).</p>
<!-- TODO table/example that shows how crossover works  -->

<h4>Mutation</h4>
<p>After the crossover the chromosome mutates thrice with some probability p. The first mutation shuffles the genes in a chromosome. The second mutation inverses some (random) part of the chromosome. The last mutation swaps two random genes. Note, that the probability that a chromosome would have two above mutations is p*p and all three mutations: p*p*p. The typical value is of the order of p=0.001 which makes two and three different types of mutations very seldom. </p>
<!-- TODO table/example that shows how mutation works  -->
<!-- TODO table/example that shows how mutation works  -->
<!-- TODO table/example that shows how mutation works  -->

<h2>Plans</h2>
<p>The plan is to write a prototype in <strong>Python</strong> which will be nice and easy and would work nicely for a whole not-too-big continent.  If it comes to the set of destinations, I have in mind small or medium ones: </p>
<ul>
  <li>South America (12 countries)</li>
  <li>Australia&Oceania (14 countries)</li>
  <li>maybe North America (23 countries).</li>
</ul>
<p>After playing with different schemes and parameters, studying scaling and converging I would like to rewrite this code in <strong>Fortran</strong> and check how much faster it is. And run the code for the whole world (about 240 countries), capital cities of the US or some other set.</p>
<p>Of course, the program will run much faster using <i>numpy</i> library, but I prototype in the simplest manner I can. Maybe at some point i rewrite it. When I will still not be bored, then I would like to play with parallelization (MPI, CUDA).</p>
