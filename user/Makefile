TARGET := riscv64gc-unknown-none-elf
RELEASE_DIR := target/$(TARGET)/release
BIN_SRC_DIR := src/bin

BIN_RS := $(wildcard $(BIN_SRC_DIR)/*.rs)
BINS := $(patsubst $(BIN_SRC_DIR)/%.rs,%,$(BIN_RS))
ELFS := $(addprefix $(RELEASE_DIR)/,$(BINS))
BINS_OUTPUT := $(addsuffix .bin,$(ELFS))

.PHONY: user_app user_bin clean

user_app:
	cargo build --release

user_bin: user_app
	$(foreach elf,$(ELFS),rust-objcopy --strip-all $(elf) -O binary $(elf).bin;)

clean:
	cargo clean

