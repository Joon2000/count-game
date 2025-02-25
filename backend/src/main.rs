use tokio::net::TcpListener;
use dotenv::dotenv;
use std::env;
use alloy::{ providers::{ Provider, ProviderBuilder }, transports::http::reqwest::Url };

async fn main() {
    dotenv().ok();

    let rpc_url: Url = env
        ::var("RPC_URL")
        .expect("RPC_URL must be set")
        .parse()
        .expect("Invalid RPC URL");
    let provider = ProviderBuilder::new().on_http(rpc_url);
}
