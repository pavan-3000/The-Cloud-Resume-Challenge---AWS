async function getVisitorCount() {
    try {
        // Replace with your actual API Gateway URL
        const response = await fetch('https://p1hx4zxas2.execute-api.ap-south-1.amazonaws.com/dev/count');
        
        // Check if the response is ok (status 200)
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }

        const data = await response.json();
        
        // Update the text content of the visitor count on the webpage
        document.getElementById('visitor-count').textContent = `This page has been visited ${data.count} times.`;
    } catch (error) {
        console.error('Error fetching visitor count:', error);
        // Display a user-friendly message if fetching fails
        document.getElementById('visitor-count').textContent = 'Error fetching data';
    }
}

// Call the function when the page loads
window.onload = getVisitorCount;
