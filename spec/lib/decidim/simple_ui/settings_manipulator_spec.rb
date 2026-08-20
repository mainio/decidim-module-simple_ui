# frozen_string_literal: true

require "spec_helper"

module Decidim
  module SimpleUi
    describe SettingsManipulator do
      subject(:manipulator) { described_class.new(settings) }

      let(:settings) do
        instance_double("Settings").tap do |s|
          allow(s).to receive(:attributes).and_return(attributes)
          allow(s).to receive(:instance_variable_set)
        end
      end

      describe "#move_attribute_after" do
        context "when both keys exist" do
          let(:attributes) { { a: 1, b: 2, c: 3, d: 4 } }

          it "moves the target key to the position after the reference key" do
            manipulator.move_attribute_after(:a, :c)

            expect(settings).to have_received(:instance_variable_set).with(
              :@attributes,
              { b: 2, c: 3, a: 1, d: 4 }
            )
          end
        end

        context "when moving the last key after the first" do
          let(:attributes) { { a: 1, b: 2, c: 3 } }

          it "places the target right after the reference" do
            manipulator.move_attribute_after(:c, :a)

            expect(settings).to have_received(:instance_variable_set).with(
              :@attributes,
              { a: 1, c: 3, b: 2 }
            )
          end
        end

        context "when the target key does not exist" do
          let(:attributes) { { a: 1, b: 2 } }

          it "does nothing" do
            manipulator.move_attribute_after(:missing, :a)

            expect(settings).not_to have_received(:instance_variable_set)
          end
        end

        context "when the reference key does not exist" do
          let(:attributes) { { a: 1, b: 2 } }

          it "does nothing" do
            manipulator.move_attribute_after(:a, :missing)

            expect(settings).not_to have_received(:instance_variable_set)
          end
        end
      end

      describe "#move_attribute_before" do
        context "when both keys exist" do
          let(:attributes) { { a: 1, b: 2, c: 3, d: 4 } }

          it "moves the target key to the position before the reference key" do
            manipulator.move_attribute_before(:d, :b)

            expect(settings).to have_received(:instance_variable_set).with(
              :@attributes,
              { a: 1, d: 4, b: 2, c: 3 }
            )
          end
        end

        context "when moving a key before the first key" do
          let(:attributes) { { a: 1, b: 2, c: 3 } }

          it "places the target at the beginning" do
            manipulator.move_attribute_before(:c, :a)

            expect(settings).to have_received(:instance_variable_set).with(
              :@attributes,
              { c: 3, a: 1, b: 2 }
            )
          end
        end

        context "when the target key does not exist" do
          let(:attributes) { { a: 1, b: 2 } }

          it "does nothing" do
            manipulator.move_attribute_before(:missing, :a)

            expect(settings).not_to have_received(:instance_variable_set)
          end
        end

        context "when the reference key does not exist" do
          let(:attributes) { { a: 1, b: 2 } }

          it "does nothing" do
            manipulator.move_attribute_before(:a, :missing)

            expect(settings).not_to have_received(:instance_variable_set)
          end
        end
      end

      describe "#reorder_attributes" do
        let(:attributes) { { c: 3, a: 1, b: 2 } }

        it "sorts the attributes hash according to the given key order" do
          manipulator.reorder_attributes([:a, :b, :c])

          expect(settings).to have_received(:instance_variable_set).with(
            :@attributes,
            { a: 1, b: 2, c: 3 }
          )
        end
      end

      describe "#settings" do
        let(:attributes) { {} }

        it "exposes the settings object" do
          expect(manipulator.settings).to eq(settings)
        end
      end
    end
  end
end
