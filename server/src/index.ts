import app from "./app";


const PORT = Number(process.env.PORT) || 8000;



app.listen(PORT, () => {
    console.log(`API server running at http://localhost:${PORT}`);
});
