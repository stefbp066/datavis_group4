<script lang="ts">
        
    import data_vis3 from '../data/monthlyrevenue.json';

    let datapoints_vis3 = data_vis3.map(d => {
    return {
        ...d,
        order : d.OrderYear.toString() + getMonthName(d.OrderMonth.toString()),
        OrderYear : Number(d.OrderYear),
        Revenue : Number(d.Revenue)
    }
    }); 

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
    };
    
    import { onMount } from 'svelte';
    import * as d3 from 'd3';
    import { nest } from 'd3-array';
    
    // Assuming you have imported data_vis3 as datapoints_vis3
    onMount(async () => {
        // Load the data
        const response = await fetch('../data/monthlyrevenue.json');
        datapoints_vis3 = await response.json();

        // Call the function to create the plot after data is loaded
        createGroupedLinePlot();
    });

    function createGroupedLinePlot(){
        // Set up SVG dimensions and margins
        let margin = { top: 20, right: 20, bottom: 30, left: 40 };
        let width = 800 - margin.left - margin.right;
        let height = 400 - margin.top - margin.bottom;

        // Append SVG to the container element
        let svg = d3.select("#chart")
            .append("svg")
            .attr("width", width + margin.left + margin.right)
            .attr("height", height + margin.top + margin.bottom)
            .append("g")
            .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

        // Group data by Type
        let nestedData = nest()
            .key((d: any) => d.Type)
            .entries(datapoints_vis3);


        // Set up scales
        let xScale = d3.scaleLinear()
            .domain([d3.min(datapoints_vis3, d => d.OrderYear), d3.max(datapoints_vis3, d => d.OrderYear)])
         .range([0, width]);

        let yScale = d3.scaleLinear()
            .domain([0, d3.max(datapoints_vis3, d => d.Revenue)])
            .range([height, 0]);

        // Set up line generator
        let line = d3.line()
            .x(d => xScale(d.OrderYear))
            .y(d => yScale(d.Revenue));

        // Append lines for each group
        nestedData.forEach(group => {
            svg.append("path")
                .datum(group.values)
                .attr("class", "line")
                .attr("d", line)
                .style("stroke", () => d3.schemeCategory10[group.key % 10]); // Change color for each group
        });


        // Append x-axis
        svg.append("g")
            .attr("transform", "translate(0," + height + ")")
            .call(d3.axisBottom(xScale).ticks(5));

        // Append y-axis
        svg.append("g")
            .call(d3.axisLeft(yScale));
    }
</script>

<div id="chart"></div>