# 目标文件名
TARGET = rCore
BINARY = rcore.bin
TARGET_PATH = target/riscv64gc-unknown-none-elf/release

# 默认目标
all: user_bin build bin

user_bin:
	cd user && $(MAKE) user_bin

# 构建 Rust 项目
build: user_bin
	@echo "Building Rust project..."
	cargo build --release

# 生成纯二进制文件
bin: build
	@echo "Generating binary file..."
	rust-objcopy --strip-all $(TARGET_PATH)/$(TARGET) -O binary $(TARGET_PATH)/$(BINARY)


# 使用 QEMU 运行
run: bin
	@echo "Running with QEMU..."
	qemu-system-riscv64 \
		-machine virt \
		-nographic \
		-bios ./bootloader/rustsbi-qemu.bin \
		-device loader,file=$(TARGET_PATH)/$(BINARY),addr=0x80200000

# 使用 QEMU 调试模式运行
debug: bin
	@echo "Running with QEMU in debug mode..."
	qemu-system-riscv64 \
		-machine virt \
		-nographic \
		-bios ./bootloader/rustsbi-qemu.bin \
		-device loader,file=$(TARGET_PATH)/$(BINARY),addr=0x80200000 \
		-s -S

# 清理构建产物
clean:
	@echo "Cleaning build artifacts..."
	cargo clean
	rm -f $(TARGET_PATH)/$(BINARY)
	cd user && $(MAKE) clean

.PHONY: all build bin run debug clean
