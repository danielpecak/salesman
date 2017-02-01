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
<p>I love to travel. I've visited many countries in Europe and I happened to be in southwest USA, I've road-tripped along Chile, I've seen Japan - plan to see a lot more including New Zealand. But the time is finite and the question is: how to travel in the optimal way to see everything, instead of bouncing around.</p>
<p>My problem is the following: given a set of N capital cities (of a given continent, continents or the whole world) I want to find the shortest path that covers all capital cities.</p>

<h2>Technical details of the project</h2>
<p>In this subsection, I will describe the theoretical background for the project and why I did things that I did.</p>
<h3>Data</h3>
<h3>Chromosome</h3>
<h3>Fitness function</h3>
<h3>Breeding</h3>
<h4>Parent selection</h4>
<h4>Crossover</h4>
<h4>Mutation</h4>

<h2>Plans</h2>
<p>The plan is to write a prototype in <strong>Python</strong> which will be nice and easy and would work nicely for a whole not-too-big continent. I have in mind: </p>
<ul>
  <li>South America (12 countries)</li>
  <li>Australia&Oceania (14 countries)</li>
  <li>maybe North America (23 countries).</li>
</ul>
<p>After playing with different schemes and parameters, studying scaling and converging I would like to rewrite code in <strong>Fortran</strong> and check how much faster it is. And run the code for the whole world (about 240 countries), capital cities of the US or some other set. At this point the program</p>
<p>When I will still not be bored, then I would like to play with parallelization (MPI, CUDA).</p>
