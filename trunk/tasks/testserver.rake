desc "Run webserver for tests (when using MRI)"
task :testserver do
  # ========= WEBRick stuff ==========
  require 'webrick'
  doc_root = File.join(File.dirname(__FILE__),"..", "spec", "html")
  log_file = File.join(File.dirname(__FILE__), "..", "log", "webrick_log.txt")
  server_port = 2000
  TEST_HOST = "http://localhost:#{server_port.to_s}"

  server = WEBrick::HTTPServer.new(:Port => server_port,
                                   :DocumentRoot => doc_root,
                                   :Logger => WEBrick::Log.new(log_file, WEBrick::BasicLog::WARN),
                                   :AccessLog => [])
  server.mount("/", WEBrick::HTTPServlet::FileHandler, doc_root, {:FancyIndexing=>true})
  WEBRICK_SERVER = Thread.new { server.start }
  WEBRICK_SERVER.join
end