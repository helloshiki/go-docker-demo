package main
import (
	"github.com/gin-gonic/gin"
)

func greeting(c *gin.Context) {
	c.JSON(200, gin.H{
		"hello": "world",
	})
}

func main() {
	router := gin.Default()
	router.GET("/v1/greeting", greeting)
	router.Run()
}