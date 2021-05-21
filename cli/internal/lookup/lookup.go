package lookup

import (
	"encoding/json"
	"errors"
	"net/http"
	"strconv"
	"time"
)

type UserModel struct {
	Avatar          string    `json:"avatar"`
	AvatarURL       string    `json:"avatar_url"`
	Bot             bool      `json:"bot"`
	Creation        time.Time `json:"creation"`
	Date            time.Time `json:"date"`
	Discriminator   string    `json:"discriminator"`
	FlagsAbstracted []string  `json:"flags_abstracted"`
	Id              string    `json:"id"`
	PublicFlags     int       `json:"public_flags"`
	RequestCount    int       `json:"request_count"`
	Username        string    `json:"username"`
}

type errorModel struct {
	Code    int      `json:"code"`
	Message string   `json:"message"`
	UserID  []string `json:"user_id"`
}

type Client struct {
	endpoint string
}

func NewClient(endpoint string) *Client {
	return &Client{endpoint}
}

func (c *Client) GetID(id string) (user *UserModel, err error) {
	res, err := http.Get(c.endpoint + "/lookup/" + id)
	if err != nil {
		return
	}

	if res.StatusCode >= 400 {
		errM := new(errorModel)
		err = json.NewDecoder(res.Body).Decode(errM)
		if err == nil {
			msg := errM.Message
			if msg == "" {
				msg = errM.Message
			}
			err = errors.New(msg)
		} else {
			err = errors.New("response error: " + strconv.Itoa(res.StatusCode))
		}
		return
	}

	user = new(UserModel)
	err = json.NewDecoder(res.Body).Decode(user)
	return
}
