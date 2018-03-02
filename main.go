package main

import (
	"os"
	"strings"
	"io/ioutil"
	"net/url"
	"net/http"
	"encoding/json"
)

type Response struct {
	Available bool `json:"available"`
}

func main() {
	http.HandleFunc("/isAvailable", func(w http.ResponseWriter, r *http.Request) {
		resp, err := http.PostForm(
			"https://verkkopalvelu.vrk.fi/nimipalvelu/nimipalvelu_sukunimihaku.asp",
			url.Values{"nimi": r.URL.Query()["name"]},
		)
		if err != nil {
			http.Error(w, err.Error(), 500)
			return
		}
		defer resp.Body.Close()
		contents, err := ioutil.ReadAll(resp.Body)
		if err != nil {
			http.Error(w, err.Error(), 500)
			return
		}


		w.Header().Set("Access-Control-Allow-Origin", "*")
		json.NewEncoder(w).Encode(Response{
			Available: strings.Contains(
				string(contents),
				"V&auml;est&ouml;tietoj&auml;rjestelm&auml;ss&auml; ei ole hakemaasi sukunime&auml;",
			),
		})
	})

	http.ListenAndServe(":" + os.Getenv("PORT"), nil)
}
