package main

import (
	"fmt"
	"html/template"
	"log"
	"net/http"
	"os"

	flag "github.com/ogier/pflag"
)

const Usage = `Usage: apiwiki [options...] <path>

Optional arguments:
  -h, --help            show this help message and exit
  -p PORT, --port=PORT  listen port (default 8080)
`

var options struct {
	Dir       string
	Port      int
	CustomCSS string

	template *template.Template
	git      bool
}

func main() {
	flag.Usage = func() {
		fmt.Fprint(os.Stderr, Usage)
	}

	flag.IntVarP(&options.Port, "port", "p", 9080, "")

	flag.Parse()

	// Parse base template
	var err error
	options.template, err = template.New("base").Parse(Template)
	if err != nil {
		log.Fatalln("Error parsing HTML template:", err)
	}
	options.Dir = "apidoc"
	// Verify that the wiki folder exists
	_, err = os.Stat(options.Dir)
	if os.IsNotExist(err) {
		log.Fatalln("Directory not found")
	}

	http.Handle("/apidoc/view", commonHandler(WikiHandler))
	http.Handle("/", commonHandler(WikiHandler))

	log.Println("Listening on:", options.Port)
	http.ListenAndServe(fmt.Sprintf(":%d", options.Port), nil)
}
