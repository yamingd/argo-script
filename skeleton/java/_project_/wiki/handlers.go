package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"path"
	"strings"
)

const imageTypes = ".jpg .jpeg .png .gif"

func WikiHandler(w http.ResponseWriter, r *http.Request) {
	filePath := r.URL.Path[1:]
	if filePath == "" {
		filePath = "index"
	}
	if strings.HasPrefix(filePath, "apidoc") {
		filePath = filePath[6:]
	}
	log.Println("view file: ", filePath)
	// Deny requests trying to traverse up the directory structure using
	// relative paths
	if strings.Contains(filePath, "..") {
		http.Error(w, http.StatusText(http.StatusBadRequest), http.StatusBadRequest)
		return
	}

	if strings.HasPrefix(filePath, "public") {
		http.ServeFile(w, r, filePath)
		return
	}

	// Path to the file as it is on the the local file system
	fsPath := fmt.Sprintf("%s/%s", options.Dir, filePath)

	// Serve (accepted) images
	for _, filext := range strings.Split(imageTypes, " ") {
		if path.Ext(r.URL.Path) == filext {
			http.ServeFile(w, r, fsPath)
			return
		}
	}

	md, err := ioutil.ReadFile(fsPath + ".md")
	if err != nil {
		http.NotFound(w, r)
		return
	}

	wiki := Wiki{
		Markdown:  md,
		CustomCSS: options.CustomCSS,
		filepath:  fsPath,
		template:  options.template,
	}

	wiki.Write(w)
}
