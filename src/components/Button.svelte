<script>
	
	let buttonProps = {
	class:[$$restProps.class]
	}

</script>
	<button on:click
			on:mouseover
			on:mouseenter
			on:mouseleave
		{...buttonProps}>
			<slot/>
	</button>


<style>
	.play-button {
        padding: 10px;
        background-color: transparent;
        border: none;
        cursor: pointer;
        transition: transform 0.9s ease;
    }

    .play-button:hover {
        transform: scale(1.1);
    }

    .play-icon {
        width: 240px;
        height: 240px;
    }
</style>