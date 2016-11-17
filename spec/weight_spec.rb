require "spec_helper"

describe "test_simple_iptables::weight" do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: "ubuntu", version: "14.04",
                             step_into: ["ruby_block", "simple_iptables_rule"])
  end

  it "generates rules in resource appearance order for every weight" do
    expected_rules =
%{# This file generated by Chef. Changes will be overwritten.
*nat
:PREROUTING ACCEPT [0:0]
:INPUT ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
:POSTROUTING ACCEPT [0:0]
COMMIT
# Completed
# This file generated by Chef. Changes will be overwritten.
*mangle
:PREROUTING ACCEPT [0:0]
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
:POSTROUTING ACCEPT [0:0]
COMMIT
# Completed
# This file generated by Chef. Changes will be overwritten.
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
:rule1 - [0:0]
:rule2 - [0:0]
:rule3 - [0:0]
:rule4 - [0:0]
:rule5 - [0:0]
:rule6 - [0:0]
-A INPUT  --jump rule1
-A rule1 --jump ACCEPT rule1 content -m comment --comment "rule1"
-A INPUT  --jump rule2
-A rule2 --jump ACCEPT rule2 content -m comment --comment "rule2"
-A INPUT  --jump rule4
-A rule4 --jump ACCEPT rule4.1 content -m comment --comment "rule4"
-A rule4 --jump ACCEPT rule4.2 content -m comment --comment "rule4"
-A INPUT  --jump rule5
-A rule5 --jump ACCEPT rule5 content -m comment --comment "rule5"
-A INPUT  --jump rule3
-A rule3 --jump REJECT rule3 content -m comment --comment "rule3"
-A INPUT  --jump rule6
-A rule6 --jump REJECT rule6 content -m comment --comment "rule6"
COMMIT
# Completed
# This file generated by Chef. Changes will be overwritten.
*raw
:PREROUTING ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
COMMIT
# Completed
}
    chef_run.converge(described_recipe)
    t = chef_run.template("/etc/iptables-rules")
    actual_content = ChefSpec::Renderer.new(chef_run, t).content
    File.open("/tmp/foo", "w") { |file| file.write(actual_content) }
    File.open("/tmp/foo1", "w") { |file| file.write(expected_rules) }
    expect(chef_run).to render_file("/etc/iptables-rules")
                        .with_content(expected_rules)
  end
end