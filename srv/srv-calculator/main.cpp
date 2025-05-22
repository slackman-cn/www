// CLion, Qt Creator
// sudo apt install build-essential cmake qtbase5-dev
// https://doc.qt.io/qt-6/qtwidgets-widgets-calculator-example.html


// create project; main widget; no ui file
// create button class < QToolButton

// calculator.h
private slots:
    void digitClicked();
    void unaryOperatorClicked();
    void additiveOperatorClicked();
    void multiplicativeOperatorClicked();
    void equalClicked();
    void pointClicked();
    void changeSignClicked();
    void backspaceClicked();
    void clear();
    void clearAll();
    void clearMemory();
    void readMemory();
    void setMemory();
    void addToMemory();