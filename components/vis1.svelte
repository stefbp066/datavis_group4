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
            content: attr(data-tooltip); /* Set tooltip content */
        }
        
        .outside-text {
            position: absolute;
            top: 0px; /* Adjust top position */
            left: 0px; /* Adjust left position */
        }

        svg text {
            display: none; /* Hide all text elements by default */
        }

        svg g:hover text {
            display: block; /* Display text elements when circle is hovered over*/
        }

</style>

<script>
    import { max, min } from 'd3';
    import data_vis1 from '../data/data_vis1.json';
    
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
        mean_revenue : Number(d.mean_revenue)
      }
    });

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
    let margins = {top: 40, right: 40, bottom: 40, left: 40};

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
    for (let i = 0; i < 60; i++) {
        setTimeout(() => {
            slider_value = i;
        }, i * 500); // Wait 500 iterations, then update slider_value
    };
    }
    
</script>

<body>

<h1 style="position: absolute; top: 5px; left: 10px;"> Visualization 1 </h1>

<!--<input type="range" min="201901" max="202312" bind:value={slider_value} /><br/>-->
<div style="position: absolute; top: 80%; left: 04%; white-space: nowrap">
    <div style="display: flex; align-items: center;"> <!-- Container for alignment -->
        <p style="margin-right: 10px;">Select which date you would like to visualize or play the animation: </p> <!-- Title -->
        <div style="display: flex; align-items: center;"> <!-- Container for line -->
            <Button on:click={play_animation}>Play</Button>
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
      <image xlink:href="http://localhost:5173/faerun_without_name.jpg" width={map_width} height={map_height} opacity="1" x = {margins.left} y = {margins.top}/>
      <image xlink:href="http://localhost:5173/faerun_without_name.jpg" width={map_width} height={map_height} opacity="1" x = {map_width + (between_plot_margin + margins.left)} y = {margins.top}/>
      
       {#each datapoints_vis1 as datapoint}
        {#if datapoint.Coord_X > 1 && datapoint.year_month == mapSliderToDateString(slider_value)
            && datapoint.mean_revenue >= slider_value_min && datapoint.mean_revenue <= slider_value_max}
            <g class = 'custom_class'>
            <circle class="circle"
            data-tooltip="test"
            cx={datapoint.Coord_X * rescaling_factor + margins.left} 
            cy={datapoint.Coord_Y * rescaling_factor + margins.top} 
            r = {(datapoint.revenue/max_revenue) * (270 * rescaling_factor)}
            fill-opacity = "0.6"
            fill = #4D4D4D 
            />

            <text class = "outside-text" x="{margins.left}" y="30"> Selected nation: {datapoint.Nation} </text>

            <circle class="circle"
            data-tooltip="test"
            cx={(datapoint.Coord_X * rescaling_factor) + map_width + margins.left + between_plot_margin}  
            cy={datapoint.Coord_Y * rescaling_factor + margins.top} 
            r = {((datapoint.revenue/datapoint.number_clients)/max_rev_per_client) * (270 * rescaling_factor)}
            fill-opacity = "0.6"
            fill = #4D4D4D 
            />
            <!--<text class = "outside-text" x="50" y="50">{datapoint.Nation}</text>-->
            </g>
            
        {/if}
        {/each}
  </svg>

  <!--
  <svg class = "plot" width={map_width} height={map_height}>
     <image xlink:href="http://localhost:5173/faerun_without_name.jpg" width={map_width} height={map_height} opacity="1"/>
  </svg>
    
  
    <image xlink:href="http://localhost:5173/faerun_without_name.jpg" width={map_width} height={map_height} opacity="1"/>
        {#each datapoints_vis1 as datapoint}
        {#if datapoint.year_month == mapSliderToDateString(slider_value)}
            <g>
            <circle class="circle"
            data-tooltip="test"
            cx={datapoint.Coord_X * rescaling_factor} 
            cy={datapoint.Coord_Y * rescaling_factor} 
            r= {((datapoint.revenue/datapoint.number_clients)/max_rev_per_client) * (270 * rescaling_factor)}
            fill-opacity = "0.6"
            fill = #4D4D4D 
            />
            <text class = "outside-text" x="50" y="50">{datapoint.Nation}</text>
            </g>
        {/if}
        {/each}
  </svg>
    -->
</body>