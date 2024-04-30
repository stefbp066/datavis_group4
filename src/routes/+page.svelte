<!-- <h1>Welcome to SvelteKit</h1>
<p>Visit <a href="https://kit.svelte.dev">kit.svelte.dev</a> to read the documentation</p>
-->
<script>
    import { min, max } from 'd3';
    
    import data_vis1 from '../data/vis1_coordinate.json';
    import data_vis3 from '../data/monthlyrevenue.json';
    
    let datapoints_vis1 = data_vis1.map(d => {
      return {
        ...d,
        Coord_X : Number(d.Coord_X),
        Coord_Y : Number(d.Coord_Y),
        CartPriceInCP : Number(d.CartPriceInCP)
      }
    });

    let datapoints_vis3 = data_vis3.map(d => {
      return {
        ...d,
        order : d.OrderYear.toString() + getMonthName(d.OrderMonth.toString()),
        OrderYear : Number(d.OrderYear),
        Revenue : Number(d.Revenue)
      }
    }); 

    console.log('LARA', datapoints_vis3[1]['order']);

    /**
     * @param {string} month_number
     */
    
    function getMonthName(month_number){
      if (month_number.length === 1) {
        return "0" + month_number
      }
      else {
        return month_number
      }
    }
  
    const rescale = function(/** @type {number} */ x, /** @type {number} */ domain_min, /** @type {number} */ domain_max, /** @type {number} */ range_min, /** @type {number} */ range_max) {
      return ((range_max - range_min)*(x-domain_min))/(domain_max-domain_min) + range_min
    }

    // THIS IS FOR VIS 1
    let rescaling_factor = 0.3;

    let map_width = 2890 * rescaling_factor;
    let map_height = 1940 * rescaling_factor;

    // THIS IS FOR VIS 3
    let margin = { top: 20, right: 20, bottom: 30, left: 40 };

    let max_revenue = max(datapoints_vis3, d => d.Revenue);
    let min_revenue = min(datapoints_vis3, d => d.Revenue);
    let max_year = max(datapoints_vis3, d => d.OrderYear);

    let vis3_width = 2890 * rescaling_factor;
    let vis3_height = 1940 * rescaling_factor;

  </script>
  
  <svg width={map_width} height={map_height}>
      <image xlink:href="http://localhost:5173/faerun.jpg" width={map_width} height={map_height} opacity="0.7"/>
        {#each datapoints_vis1 as datapoint}
        {#if datapoint.year_month == "2019-03"}
            <circle cx={datapoint.Coord_X * rescaling_factor} cy={datapoint.Coord_Y * rescaling_factor} r= {10 * (rescaling_factor + .1)} />
        {/if}
        {/each}
  </svg>

