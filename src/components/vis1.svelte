<style>
    .plot {
        top: 50%;
        left: 50%;
    }

    .custom_class:hover .circle {
        fill-opacity: 0.8;
        content: attr(data-tooltip); /* Set tooltip content */
    }

    .circle:hover {
        fill-opacity : 0.8;
    }

    .circle:hover title {
        display: block;
        position: absolute;
        z-index: 1;
        background-color: white;
        border: 1px solid black;
        padding: 5px;
    }

</style>

<script>
    import { max, min } from 'd3';
    import data_vis1 from '../data/data_vis1.json';
    
    // hover

    import Button from './Button.svelte';   

    let datapoints_vis1 = data_vis1.map(d => {
      return {
        ...d,
        Coord_X : Number(d.Coord_X),
        Coord_Y : Number(d.Coord_Y),
        revenue : Number(d.revenue),
        year_month : d.year_month.toString(),
        number_clients : Number(d.number_clients),
        Nation : d.Nation.toString(),
        mean_revenue : Number(d.mean_revenue),
        rank : Number(d.rank)
      }
    });

    let max_total_nation_revenue = max(datapoints_vis1, d => d.sum_rev);

    //values for second slider
    let min_mean_revenue = min(datapoints_vis1, d => d.mean_revenue);
    let max_mean_revenue = max(datapoints_vis1, d => d.mean_revenue);

    let slider_value_min = min_mean_revenue;
    let slider_value_max = max_mean_revenue;

    // end of vals for second slider

    let rescaling_factor = 0.2;

    let map_width = 2890 * rescaling_factor;
    let map_height = 1940 * rescaling_factor;
    
    let between_plot_margin = 30;
    let margins = {top: 150, right: 40, bottom: 40, left: 40};

    let max_revenue = max(datapoints_vis1, d => d.revenue);
    let max_rev_per_client = max(datapoints_vis1, d => d.revenue/d.number_clients);

    /**
    * @param {number} month
    */

    let month; // initialize variable month

    let slider_value = 0;  //initialize slider_value (will start at 2019-01)

    /**
    *@param {number} slider_value
    */

    function mapSliderToDateString(slider_value) {
    var year = Math.floor(slider_value / 12) + 2019;
    var month_number = (slider_value % 12) + 1;
    if (month_number < 10) {
        month = "0" + month_number;
    }else{
        month = month_number;
    }
    return year + "-" + month};

    function play_animation() {
        // Start animation loop
        let i = slider_value; // Start from current slider value
        const interval = setInterval(() => {
        if (!isPlaying) {
            clearInterval(interval); // Stop the animation loop if paused
            return;
        }
        slider_value = i;
        i++;
        if (i >= 60) {
            clearInterval(interval); // Stop the animation loop if end reached
        }
        }, 250); // Wait 500 milliseconds between iterations
    }

    let isPlaying = false; // Initialize the variable to control animation state

    function toggleAnimation() {
        isPlaying = !isPlaying; // Toggle the animation state
        if (isPlaying) {
            play_animation(); // If animation is resumed, start playing
        }
    }

    // for regional manager coloring
    import { interpolateRgb } from 'd3-interpolate';
    import { scaleOrdinal } from 'd3-scale';

    // Extract unique regional managers
    const uniqueManagers = [...new Set(datapoints_vis1.map(d => d['Regional.Manager']))];

    // Define a color scale mapping each regional manager to a color
    const colorSet = ['#1f77b4', '#aec7e8', '#ff7f0e', '#ffbb78', '#2ca02c', '#98df8a','#d62728',
            '#ff9896','#9467bd','#c5b0d5','#8c564b','#c49c94','#e377c2','#f7b6d2',
            '#7f7f7f','#c7c7c7','#bcbd22','#dbdb8d','#17becf','#9edae5','#393b79',
            '#5254a3','#6b6ecf','#9c9ede','#637939','#8ca252','#b5cf6b','#cedb9c',
            '#8c6d31','#bd9e39','#e7ba52','#e7cb94','#843c39','#ad494a','#d6616b'
        ]; // Add more colors as needed

    // Function to get the fill color based on regional manager
    function getFillColor(manager) {
        // Map each regional manager to a specific color from the color set
        // If there are more than 35 regional managers, this will cycle through the colors
        return colorSet[uniqueManagers.indexOf(manager) % colorSet.length];
  }
    
</script>

<body>

<h1 style="position: absolute; top: 5px; left: 10px;"> Visualization 1 </h1>

<!--<input type="range" min="201901" max="202312" bind:value={slider_value} /><br/>-->
<div style="position: absolute; top: 80%; left: 04%; white-space: nowrap">
    <div style="display: flex; align-items: center;"> <!-- Container for alignment -->
        <p style="margin-right: 10px;">Select which date you would like to visualize or play the animation: </p> <!-- Title -->
        <div style="display: flex; align-items: center;"> <!-- Container for line -->
            <Button on:click={toggleAnimation}>{isPlaying ? 'Pause' : 'Play'}</Button>
            <p style="margin-left: 10px; margin-right: 10px"> <!-- Aligning items in line -->
                <input style="margin-right: 10px;" type="range" min="0" max="59" step="1" bind:value={slider_value} />
            </p>    
            Date: {mapSliderToDateString(slider_value)}
        </div>
    </div>
</div>

<div style = 'position: absolute; top: 85%; left: 04%; white-space: nowrap'>
    <div style="display: flex; align-items: center;">
        <p>Select specific nations based on their mean revenue, choose a minimum and maximum range in the sliders: </p>
        <input style="margin-left: 20px;" type="range" min={min_mean_revenue - 100} max={max_mean_revenue + 100} step="100" bind:value={slider_value_min} />
        <input style="margin-right: 20px;" type="range" min={min_mean_revenue - 100} max={max_mean_revenue + 100} step="100" bind:value={slider_value_max} />
    </div>
    <div style="display: flex">
        <p style = "display: flex; margin-left: 720px; margin-top: -10px">Selected range: {Math.round(slider_value_min)} - {Math.round(slider_value_max)} Copper Pieces (CP)</p>
        <p style = "display: flex; margin-left: -342px; margin-top: 20px">Number of nations in range: {datapoints_vis1.filter(d => d.year_month == '2019-01' && slider_value_min && d.mean_revenue >= slider_value_min && d.mean_revenue <= slider_value_max).length}</p>
    </div>
    </div>

<!--The actual plot-->
<svg class = "plot" width={map_width*2 + (between_plot_margin + margins.left + margins.right)} height={map_height + margins.top + margins.bottom}>
    <image xlink:href="../faerun_without_name.jpg" width={map_width} height={map_height} opacity="0.75" x = {margins.left} y = {margins.top}/>
    <image xlink:href="../faerun_without_name.jpg" width={map_width} height={map_height} opacity="0.75" x = {map_width + (between_plot_margin + margins.left)} y = {margins.top}/>
       {#each datapoints_vis1 as datapoint}
       <g class = 'custom_class'>
        {#if datapoint.Coord_X > 1 && datapoint.year_month == mapSliderToDateString(slider_value)
            && datapoint.mean_revenue >= slider_value_min && datapoint.mean_revenue <= slider_value_max}
            
            <circle class="circle"
            data-tooltip="{datapoint.Nation}: Mean Revenue: {datapoint.mean_revenue}, Revenue per Client: {datapoint.mean_revenue / datapoint.mean_number_clients}"
            cx={datapoint.Coord_X * rescaling_factor + margins.left} 
            cy={datapoint.Coord_Y * rescaling_factor + margins.top} 
            r={(datapoint.revenue / max_revenue) * (270 * rescaling_factor)}
            fill-opacity="0.6"
            fill={getFillColor(datapoint['Regional.Manager'])}
            >
            <title>Nation: {datapoint.Nation} &#013;Mean Revenue: {datapoint.mean_revenue.toFixed(0)} &#013;Revenue per Client: {(datapoint.mean_revenue / datapoint.mean_number_clients).toFixed(0)} &#013;Regional Manager: {datapoint['Regional.Manager']}</title>
            </circle>

            <circle class="circle"
            data-tooltip="{datapoint.Nation}: Mean Revenue: {datapoint.mean_revenue}, Revenue per Client: {datapoint.mean_revenue / datapoint.mean_number_clients}"
            cx={(datapoint.Coord_X * rescaling_factor) + map_width + margins.left + between_plot_margin}  
            cy={datapoint.Coord_Y * rescaling_factor + margins.top} 
            r={((datapoint.revenue / datapoint.number_clients) / max_rev_per_client) * (270 * rescaling_factor)}
            fill-opacity="0.6"
            fill={getFillColor(datapoint['Regional.Manager'])}
            >
            <title>Nation: {datapoint.Nation} &#013;Mean Revenue: {datapoint.mean_revenue.toFixed(0)} &#013;Revenue per Client: {(datapoint.mean_revenue / datapoint.mean_number_clients).toFixed(0)} &#013;Regional Manager: {datapoint['Regional.Manager']}</title>
            </circle>
            <!--<text class = "outside-text" x="50" y="50">{datapoint.Nation}</text>-->
             
        {/if}
        
        {#if datapoint.rank <= 5 && datapoint.year_month ==  '2019-01'}
            <circle class="circle" 
            cx= {margins.left + between_plot_margin + map_width *2 + (datapoint.rank-1)*-170 -(datapoint.sum_rev/max_total_nation_revenue) * (270 * rescaling_factor)} 
            cy={margins.top/2} 
            r = {(datapoint.sum_rev/max_total_nation_revenue) * (270 * rescaling_factor)} 
            fill={getFillColor(datapoint['Regional.Manager'])}
            fill-opacity = "0.6"
            >
            <title>Nation: {datapoint.Nation} &#013;Mean Revenue: {datapoint.mean_revenue.toFixed(0)}; &#013 Mean Revenue per Client: {(datapoint.mean_revenue / datapoint.mean_number_clients).toFixed(0)} &#013;Regional Manager: {datapoint['Regional.Manager']}</title>
            </circle>
            <text x ={margins.left + between_plot_margin + map_width *2 + (datapoint.rank-1)*-170 -(datapoint.sum_rev/max_total_nation_revenue) * (270 * rescaling_factor)}
            y={margins.top/2 + 5}
            style="font-size: 20px;"
            text-anchor="middle"
            >{datapoint.Nation}</text>
        {/if}

        </g>
        {/each}
        
        <text x={margins.left + 450} y={20} style="font-size: 25px;">Top 5 Nations by Total Revenue</text>
  </svg>

</body>